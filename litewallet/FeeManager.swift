import FirebaseAnalytics
import Foundation

// this is the default that matches the mobile-api if the server is unavailable
private let defaultEconomyFeePerKB: UInt64 = 8000 // Updated Dec 2, 2024
private let defaultRegularFeePerKB: UInt64 = 25000
private let defaultLuxuryFeePerKB: UInt64 = 66746
private let defaultTimestamp: UInt64 = 1_583_015_199_122

struct Fees: Equatable {
	let luxury: UInt64
	let regular: UInt64
	let economy: UInt64
	let timestamp: UInt64

	static var usingDefaultValues: Fees {
		return Fees(luxury: defaultLuxuryFeePerKB,
		            regular: defaultRegularFeePerKB,
		            economy: defaultEconomyFeePerKB,
		            timestamp: defaultTimestamp)
	}
}

enum FeeType {
	case regular
	case economy
	case luxury
}

class FeeUpdater: Trackable {
	// MARK: - Private

	private let walletManager: WalletManager
	private let store: Store
	private lazy var minFeePerKB: UInt64 = Fees.usingDefaultValues.economy

	private let maxFeePerKB = Fees.usingDefaultValues.luxury
	private var timer: Timer?
	private let feeUpdateInterval: TimeInterval = 3
	private var exchangeUpdater: ExchangeUpdater

	// MARK: - Public

	init(walletManager: WalletManager, store: Store, exchangeUpdater: ExchangeUpdater) {
		self.walletManager = walletManager
		self.store = store
		self.exchangeUpdater = exchangeUpdater
	}

	func refresh(completion: @escaping () -> Void) {
		walletManager.apiClient?.feePerKb { newFees, error in
			guard error == nil
			else {
				let properties: [String: String] = ["ERROR_MESSAGE": String(describing: error),
				                                    "ERROR_TYPE": "FEE_PER_KB"]
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
				completion()
				return
			}

			if newFees == Fees.usingDefaultValues {
				LWAnalytics.logEventWithParameters(itemName: ._20200301_DUDFPK)
				self.saveEvent("wallet.didUseDefaultFeePerKB")
			}

			self.store.perform(action: UpdateFees.set(newFees))
			completion()
		}

		if timer == nil {
			timer = Timer.scheduledTimer(timeInterval: feeUpdateInterval,
			                             target: self,
			                             selector: #selector(intervalRefresh),
			                             userInfo: nil, repeats: true)
		}
	}

	func refresh() {
		refresh(completion: {})
	}

	@objc func intervalRefresh() {
		refresh(completion: {})
		exchangeUpdater.refresh(completion: {
			/// DEV: For testing
			/// NSLog("::: Rate updated")
		})
	}
}
