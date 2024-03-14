import AVFoundation
import Foundation
import UIKit

private let lastBlockHeightKey = "LastBlockHeightKey"
private let progressUpdateInterval: TimeInterval = 0.5
private let updateDebounceInterval: TimeInterval = 0.4

class WalletCoordinator: Subscriber, Trackable {
	var kvStore: BRReplicatedKVStore? {
		didSet {
			requestTxUpdate()
		}
	}

	private let walletManager: WalletManager
	private let store: Store
	private var progressTimer: Timer?
	private var updateTimer: Timer?
	private let defaults = UserDefaults.standard
	private var backgroundTaskId: UIBackgroundTaskIdentifier?
	private var reachability = ReachabilityMonitor()
	private var retryTimer: RetryTimer?

	init(walletManager: WalletManager, store: Store) {
		self.walletManager = walletManager
		self.store = store
		addWalletObservers()
		addSubscriptions()
		updateBalance()
		reachability.didChange = { [weak self] isReachable in
			self?.reachabilityDidChange(isReachable: isReachable)
		}
	}

	private var lastBlockHeight: UInt32 {
		set {
			defaults.set(newValue, forKey: lastBlockHeightKey)
		}
		get {
			return UInt32(defaults.integer(forKey: lastBlockHeightKey))
		}
	}

	@objc private func updateProgress() {
		DispatchQueue.walletQueue.async {
			guard let progress = self.walletManager.peerManager?.syncProgress(fromStartHeight: self.lastBlockHeight), let timestamp = self.walletManager.peerManager?.lastBlockTimestamp else { return }
			DispatchQueue.main.async {
				self.store.perform(action: WalletChange.setProgress(progress: progress, timestamp: timestamp))
			}
		}
		updateBalance()
	}

	private func onSyncStart() {
		endBackgroundTask()
		startBackgroundTask()
		progressTimer = Timer.scheduledTimer(timeInterval: progressUpdateInterval, target: self, selector: #selector(WalletCoordinator.updateProgress), userInfo: nil, repeats: true)
		store.perform(action: WalletChange.setSyncingState(.syncing))
		startActivity()
	}

	private func onSyncStop(notification: Notification) {
		if UIApplication.shared.applicationState != .active {
			DispatchQueue.walletQueue.async {
				self.walletManager.peerManager?.disconnect()
			}
		}
		endBackgroundTask()
		if notification.userInfo != nil {
			guard let code = notification.userInfo?["errorCode"] else { return }
			guard let message = notification.userInfo?["errorDescription"] else { return }
			store.perform(action: WalletChange.setSyncingState(.connecting))
			saveEvent("event.syncErrorMessage", attributes: ["message": "\(message) (\(code))"])
			endActivity()

			if retryTimer == nil, reachability.isReachable {
				retryTimer = RetryTimer()
				retryTimer?.callback = strongify(self) { myself in
					myself.store.trigger(name: .retrySync)
				}
				retryTimer?.start()
			}

			return
		}
		retryTimer?.stop()
		retryTimer = nil
		if let height = walletManager.peerManager?.lastBlockHeight {
			lastBlockHeight = height
		}
		progressTimer?.invalidate()
		progressTimer = nil
		store.perform(action: WalletChange.setSyncingState(.success))
		endActivity()
	}

	private func endBackgroundTask() {
		if let taskId = backgroundTaskId {
			UIApplication.shared.endBackgroundTask(taskId)
			backgroundTaskId = nil
		}
	}

	private func startBackgroundTask() {
		backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
			DispatchQueue.walletQueue.async {
				self.walletManager.peerManager?.disconnect()
			}
		})
	}

	private func requestTxUpdate() {
		if updateTimer == nil {
			updateTimer = Timer.scheduledTimer(timeInterval: updateDebounceInterval, target: self, selector: #selector(updateTransactions), userInfo: nil, repeats: false)
		}
	}

	@objc private func updateTransactions() {
		updateTimer?.invalidate()
		updateTimer = nil
		DispatchQueue.walletQueue.async {
			guard let txRefs = self.walletManager.wallet?.transactions else {
				let properties = ["error_message": "wallet_tx_refs_are_nil"]
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
				return
			}
			let transactions = self.makeTransactionViewModels(transactions: txRefs, walletManager: self.walletManager, kvStore: self.kvStore, rate: self.store.state.currentRate)
			if !transactions.isEmpty {
				DispatchQueue.main.async {
					self.store.perform(action: WalletChange.setTransactions(transactions))
				}
			} else {
				let properties = ["transactions_info": "no_txs_found_in_wallet"]
				LWAnalytics.logEventWithParameters(itemName: ._20240214_TI, properties: properties)
			}
		}
	}

	func makeTransactionViewModels(transactions: [BRTxRef?], walletManager: WalletManager, kvStore: BRReplicatedKVStore?, rate: Rate?) -> [Transaction]
	{
		///  Send analytical  data for any nils in this method
		if kvStore == nil {
			let properties = ["error_message": "replicated_kv_store_is_nil"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
		}

		if rate == nil {
			let properties = ["error_message": "rate_is_nil"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
		}

		return transactions.compactMap { $0 }.sorted {
			if $0.pointee.timestamp == 0 {
				return true
			} else if $1.pointee.timestamp == 0 {
				return false
			} else {
				return $0.pointee.timestamp > $1.pointee.timestamp
			}
		}.compactMap {
			Transaction($0, walletManager: walletManager, kvStore: kvStore, rate: rate)
		}
	}

	private func addWalletObservers() {
		weak var myself = self
		NotificationCenter.default.addObserver(forName: .walletBalanceChangedNotification, object: nil, queue: nil, using: {
			_ in
			myself?.updateBalance()
			myself?.requestTxUpdate()
		})

		NotificationCenter.default.addObserver(forName: .walletTxStatusUpdateNotification, object: nil, queue: nil, using: { _ in
			myself?.requestTxUpdate()
		})

		NotificationCenter.default.addObserver(forName: .walletTxRejectedNotification, object: nil, queue: nil, using: { note in
			guard let recommendRescan = note.userInfo?["recommendRescan"] as? Bool else { return }
			myself?.requestTxUpdate()
			if recommendRescan {
				myself?.store.perform(action: RecommendRescan.set(recommendRescan))
			}
		})

		NotificationCenter.default.addObserver(forName: .walletSyncStartedNotification, object: nil, queue: nil, using: { _ in
			myself?.onSyncStart()
		})

		NotificationCenter.default.addObserver(forName: .walletSyncStoppedNotification, object: nil, queue: nil, using: { note in
			myself?.onSyncStop(notification: note)
		})

		NotificationCenter.default.addObserver(forName: .languageChangedNotification, object: nil, queue: nil, using: { _ in
			myself?.updateTransactions()
		})
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	private func updateBalance() {
		DispatchQueue.walletQueue.async {
			guard let newBalance = self.walletManager.wallet?.balance else { return }
			DispatchQueue.main.async {
				self.checkForReceived(newBalance: newBalance)
				self.store.perform(action: WalletChange.setBalance(newBalance))
			}
		}
	}

	private func checkForReceived(newBalance: UInt64) {
		if let oldBalance = store.state.walletState.balance {
			if newBalance > oldBalance {
				if store.state.walletState.syncState == .success {
					showReceived(amount: newBalance - oldBalance)
				}
			}
		}
	}

	private func showReceived(amount: UInt64) {
		if let rate = store.state.currentRate {
			let amount = Amount(amount: amount, rate: rate, maxDigits: store.state.maxDigits)
			let primary = store.state.isLtcSwapped ? amount.localCurrency : amount.bits
			let secondary = store.state.isLtcSwapped ? amount.bits : amount.localCurrency
			let message = String(format: S.TransactionDetails.received.localize(), "\(primary) (\(secondary))")
			store.trigger(name: .lightWeightAlert(message))
			showLocalNotification(message: message)
			ping()
		}
	}

	private func ping() {
		if let url = Bundle.main.url(forResource: "coinflip", withExtension: "aiff") {
			var id: SystemSoundID = 0
			AudioServicesCreateSystemSoundID(url as CFURL, &id)
			AudioServicesAddSystemSoundCompletion(id, nil, nil, { soundId, _ in
				AudioServicesDisposeSystemSoundID(soundId)
			}, nil)
			AudioServicesPlaySystemSound(id)
		}
	}

	private func showLocalNotification(message: String) {
		guard UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive else { return }
		guard store.state.isPushNotificationsEnabled else { return }
		UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
		let notification =
			UILocalNotification()
		notification.alertBody = message
		notification.soundName = "coinflip.aiff"
		UIApplication.shared.presentLocalNotificationNow(notification)
	}

	private func reachabilityDidChange(isReachable: Bool) {
		if !isReachable {
			DispatchQueue.walletQueue.async {
				self.walletManager.peerManager?.disconnect()
				DispatchQueue.main.async {
					self.store.perform(action: WalletChange.setSyncingState(.connecting))
				}
			}
		}
	}

	private func addSubscriptions() {
		store.subscribe(self, name: .retrySync, callback: { _ in
			DispatchQueue.walletQueue.async {
				self.walletManager.peerManager?.connect()
			}
		})

		store.subscribe(self, name: .rescan, callback: { _ in
			self.store.perform(action: RecommendRescan.set(false))
			// In case rescan is called while a sync is in progess
			// we need to make sure it's false before a rescan starts
			// self.store.perform(action: WalletChange.setIsSyncing(false))
			DispatchQueue.walletQueue.async {
				self.walletManager.peerManager?.rescan()
			}
		})

		store.subscribe(self, name: .rescan, callback: { _ in
			self.store.perform(action: WalletChange.setIsRescanning(true))
		})
	}

	private func startActivity() {
		UIApplication.shared.isIdleTimerDisabled = true
	}

	private func endActivity() {
		UIApplication.shared.isIdleTimerDisabled = false
	}
}
