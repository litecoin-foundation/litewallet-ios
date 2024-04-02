import BackgroundTasks
import StoreKit
import UIKit

let timeSinceLastExitKey = "TimeSinceLastExit"
let shouldRequireLoginTimeoutKey = "ShouldRequireLoginTimeoutKey"
let numberOfLitewalletLaunches = "NumberOfLitewalletLaunches"
let hasSeenAnnounceView = "HasSeedAnnounceView"
let LITEWALLET_APP_STORE_ID = 1_119_332_592

class ApplicationController: Subscriber, Trackable {
	// Ideally the window would be private, but is unfortunately required
	// by the UIApplicationDelegate Protocol

	var window: UIWindow?
	fileprivate let store = Store()
	private var startFlowController: StartFlowPresenter?
	private var modalPresenter: ModalPresenter?
	fileprivate var walletManager: WalletManager?
	private var walletCoordinator: WalletCoordinator?
	private var exchangeUpdater: ExchangeUpdater?
	private var feeUpdater: FeeUpdater?
	private let transitionDelegate: ModalTransitionDelegate
	private var kvStoreCoordinator: KVStoreCoordinator?
	private var mainViewController: MainViewController?
	fileprivate var application: UIApplication?
	private var urlController: URLController?
	private var defaultsUpdater: UserDefaultsUpdater?
	private var reachability = ReachabilityMonitor()
	private let noAuthApiClient = BRAPIClient(authenticator: NoAuthAuthenticator())
	private var fetchCompletionHandler: ((UIBackgroundFetchResult) -> Void)?
	private var launchURL: URL?
	private var hasPerformedWalletDependentInitialization = false
	private var didInitWallet = false

	init() {
		transitionDelegate = ModalTransitionDelegate(type: .transactionDetail, store: store)
		DispatchQueue.walletQueue.async {
			guardProtected(queue: DispatchQueue.walletQueue) {
				self.initWallet()
			}
		}
	}

	private func initWallet() {
		walletManager = try? WalletManager(store: store, dbPath: nil)
		_ = walletManager?.wallet // attempt to initialize wallet
		DispatchQueue.main.async {
			self.didInitWallet = true
			if !self.hasPerformedWalletDependentInitialization {
				self.didInitWalletManager()
			}
		}
	}

	func launch(application: UIApplication, window: UIWindow?) {
		self.application = application
		self.window = window
		setup()
		reachability.didChange = { isReachable in
			if !isReachable {
				self.reachability.didChange = { isReachable in
					if isReachable {
						self.retryAfterIsReachable()
					}
				}
			}
		}

		if !hasPerformedWalletDependentInitialization, didInitWallet {
			didInitWalletManager()
		}
	}

	private func setup() {
		setupRootViewController()
		window?.makeKeyAndVisible()
		offMainInitialization()
		store.subscribe(self, name: .reinitWalletManager(nil), callback: {
			guard let trigger = $0 else { return }
			if case let .reinitWalletManager(callback) = trigger {
				if let callback = callback {
					self.store.removeAllSubscriptions()
					self.store.perform(action: Reset())
					self.setup()
					DispatchQueue.walletQueue.async {
						do {
							self.walletManager = try WalletManager(store: self.store, dbPath: nil)
							_ = self.walletManager?.wallet // attempt to initialize wallet
						} catch {
							assertionFailure("Error creating new wallet: \(error)")
						}
						DispatchQueue.main.async {
							self.didInitWalletManager()
							callback()
						}
					}
				}
			}
		})

		TransactionManager.sharedInstance.fetchTransactionData(store: store)
	}

	func willEnterForeground() {
		guard let walletManager = walletManager else { return }
		guard !walletManager.noWallet else { return }
		if shouldRequireLogin() {
			store.perform(action: RequireLogin())
		}
		DispatchQueue.walletQueue.async {
			walletManager.peerManager?.connect()
		}
		exchangeUpdater?.refresh(completion: {})
		feeUpdater?.refresh()
		walletManager.apiClient?.kv?.syncAllKeys { print("KV finished syncing. err: \(String(describing: $0))") }
		if modalPresenter?.walletManager == nil {
			modalPresenter?.walletManager = walletManager
		}
	}

	func retryAfterIsReachable() {
		guard let walletManager = walletManager else { return }
		guard !walletManager.noWallet else { return }
		DispatchQueue.walletQueue.async {
			walletManager.peerManager?.connect()
		}
		exchangeUpdater?.refresh(completion: {})
		feeUpdater?.refresh()
		walletManager.apiClient?.kv?.syncAllKeys { print("KV finished syncing. err: \(String(describing: $0))") }
		if modalPresenter?.walletManager == nil {
			modalPresenter?.walletManager = walletManager
		}
	}

	func didEnterBackground() {
		if store.state.walletState.syncState == .success {
			DispatchQueue.walletQueue.async {
				self.walletManager?.peerManager?.disconnect()
			}
		}
		// Save the backgrounding time if the user is logged in
		if !store.state.isLoginRequired {
			UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: timeSinceLastExitKey)
		}
		walletManager?.apiClient?.kv?.syncAllKeys { print("KV finished syncing. err: \(String(describing: $0))") }
	}

	func performFetch(_ completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		fetchCompletionHandler = completionHandler
	}

	func open(url: URL) -> Bool {
		if let urlController = urlController {
			return urlController.handleUrl(url)
		} else {
			launchURL = url
			return false
		}
	}

	private func didInitWalletManager() {
		guard let walletManager = walletManager else { assertionFailure("WalletManager should exist!"); return }
		guard let rootViewController = window?.rootViewController else { return }
		guard let window = window else { return }

		hasPerformedWalletDependentInitialization = true
		store.perform(action: PinLength.set(walletManager.pinLength))
		walletCoordinator = WalletCoordinator(walletManager: walletManager, store: store)
		modalPresenter = ModalPresenter(store: store, walletManager: walletManager, window: window, apiClient: noAuthApiClient)
		exchangeUpdater = ExchangeUpdater(store: store, walletManager: walletManager)
		feeUpdater = FeeUpdater(walletManager: walletManager, store: store)
		startFlowController = StartFlowPresenter(store: store, walletManager: walletManager, rootViewController: rootViewController)
		mainViewController?.walletManager = walletManager
		defaultsUpdater = UserDefaultsUpdater(walletManager: walletManager)
		urlController = URLController(store: store, walletManager: walletManager)
		if let url = launchURL {
			_ = urlController?.handleUrl(url)
			launchURL = nil
		}

		if UIApplication.shared.applicationState != .background {
			if walletManager.noWallet {
				addWalletCreationListener()
				store.perform(action: ShowStartFlow())
			} else {
				modalPresenter?.walletManager = walletManager
				DispatchQueue.walletQueue.async {
					walletManager.peerManager?.connect()
				}
				startDataFetchers()
			}

			// For when watch app launches app in background
		} else {
			DispatchQueue.walletQueue.async { [weak self] in
				walletManager.peerManager?.connect()
				if self?.fetchCompletionHandler != nil {
					self?.performBackgroundFetch()
				}
			}

			exchangeUpdater?.refresh(completion: {
				let properties = ["application_controller": "rate_was_updated"]
				LWAnalytics.logEventWithParameters(itemName: ._20240315_AI, properties: properties)
			})
		}
	}

	private func shouldRequireLogin() -> Bool {
		let then = UserDefaults.standard.double(forKey: timeSinceLastExitKey)
		let timeout = UserDefaults.standard.double(forKey: shouldRequireLoginTimeoutKey)
		let now = Date().timeIntervalSince1970
		return now - then > timeout
	}

	private func setupRootViewController() {
		mainViewController = MainViewController(store: store)
		window?.rootViewController = mainViewController
	}

	private func startDataFetchers() {
		initKVStoreCoordinator()
		feeUpdater?.refresh()
		defaultsUpdater?.refresh()
		walletManager?.apiClient?.events?.up()

		exchangeUpdater?.refresh(completion: {
			NSLog("::: Refreshed fiat rates")
		})
	}

	private func addWalletCreationListener() {
		store.subscribe(self, name: .didCreateOrRecoverWallet, callback: { _ in
			self.modalPresenter?.walletManager = self.walletManager
			self.startDataFetchers()
			self.mainViewController?.didUnlockLogin()
		})
	}

	private func initKVStoreCoordinator() {
		guard let kvStore = walletManager?.apiClient?.kv
		else {
			let properties = ["applications_info": "kvstore_not_initialized"]
			LWAnalytics.logEventWithParameters(itemName: ._20240315_AI, properties: properties)
			return
		}

		guard kvStoreCoordinator == nil
		else {
			let properties = ["applications_info": "kvstorecoordinator_not_initialized"]
			LWAnalytics.logEventWithParameters(itemName: ._20240315_AI, properties: properties)
			return
		}

		kvStore.syncAllKeys { error in
			let properties = ["error_message": "kv_finished_syning",
			                  "error": "\(String(describing: error))"]
			LWAnalytics.logEventWithParameters(itemName: ._20240315_AI, properties: properties)
			self.walletCoordinator?.kvStore = kvStore
			self.kvStoreCoordinator = KVStoreCoordinator(store: self.store, kvStore: kvStore)
			self.kvStoreCoordinator?.retreiveStoredWalletInfo()
			self.kvStoreCoordinator?.listenForWalletChanges()
		}
	}

	private func offMainInitialization() {
		DispatchQueue.global(qos: .background).async {
			_ = Rate.symbolMap // Initialize currency symbol map
		}
	}

	func performBackgroundFetch() {
		saveEvent("appController.performBackgroundFetch")
		let group = DispatchGroup()
		if let peerManager = walletManager?.peerManager, peerManager.syncProgress(fromStartHeight: peerManager.lastBlockHeight) < 1.0
		{
			group.enter()
			LWAnalytics.logEventWithParameters(itemName: ._20200111_DEDG)

			store.lazySubscribe(self, selector: { $0.walletState.syncState != $1.walletState.syncState }, callback: { state in
				if self.fetchCompletionHandler != nil {
					if state.walletState.syncState == .success {
						DispatchQueue.walletConcurrentQueue.async {
							peerManager.disconnect()
							self.saveEvent("appController.peerDisconnect")
							DispatchQueue.main.async {
								LWAnalytics.logEventWithParameters(itemName: ._20200111_DLDG)
								group.leave()
							}
						}
					}
				}
			})
		}

		group.enter()
		LWAnalytics.logEventWithParameters(itemName: ._20200111_DEDG)
		Async.parallel(callbacks: [
			{ self.exchangeUpdater?.refresh(completion: $0) },
			{ self.feeUpdater?.refresh(completion: $0) },
			{ self.walletManager?.apiClient?.events?.sync(completion: $0) },
		], completion: {
			LWAnalytics.logEventWithParameters(itemName: ._20200111_DLDG)
			group.leave()
		})

		DispatchQueue.global(qos: .utility).async {
			if group.wait(timeout: .now() + 25.0) == .timedOut {
				self.saveEvent("appController.backgroundFetchFailed")
				self.fetchCompletionHandler?(.failed)
			} else {
				self.saveEvent("appController.backgroundFetchNewData")
				self.fetchCompletionHandler?(.newData)
			}
			self.fetchCompletionHandler = nil
		}
	}
}
