import Foundation
import KeychainAccess
import SwiftUI

class CardViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var isLoggedIn: Bool = false

	@Published
	var isNotRegistered: Bool = true

	@Published
	var cardWalletDetails: CardWalletDetails?

	@Published
	var litewalletBalance: Double = 0.0

	@ObservedObject
	var cardTwoFactor = CardTwoFactor()

	// MARK: - Public Variables

	var walletManager: WalletManager

	var store: Store

	init(walletManager: WalletManager,
	     store: Store)
	{
		self.walletManager = walletManager

		self.store = store

		calculatedLitewalletBalance()
	}

	func calculatedLitewalletBalance() {
		if let balance = walletManager.wallet?.balance,
		   let rate = store.state.currentRate
		{
			litewalletBalance = Amount(amount: balance,
			                           rate: rate,
			                           maxDigits: store.state.maxDigits).amountForLtcFormat
		}
	}

	/// Fetch Card Wallet details from the Ternio server
	/// - Parameter completion: All is well
	func fetchCardWalletDetails(completion _: @escaping () -> Void) {
		let keychain = Keychain(service: "com.litecoincard.service")

		// Fetches the latest token and UserID
		guard let token = keychain["token"],
		      let userID = keychain["userID"]
		else {
			LWAnalytics.logEventWithParameters(itemName: ._20210804_ERR_KLF)
			return
		}

		PartnerAPI.shared.getWalletDetails(userID: userID) { data in

			do {
				let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])

				let decoder = JSONDecoder()

				let walletDetails = try? decoder.decode(CardWalletDetails.self, from: jsonData)

				DispatchQueue.main.async {
					self.cardWalletDetails = walletDetails
					LWAnalytics.logEventWithParameters(itemName: ._20210804_TAWDS)
				}
			} catch {
				print("Error: Incomplete dictionary data from partner API")
				LWAnalytics.logEventWithParameters(itemName: ._20210405_TAWDF)
			}
		}
	}
}
