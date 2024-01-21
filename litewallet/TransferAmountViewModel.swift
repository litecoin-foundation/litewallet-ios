import BRCore
import Foundation
import KeychainAccess
import UIKit

// DEV: To be removed in following issue https://github.com/litecoin-foundation/litewallet-ios/issues/177

class TransferAmountViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var walletType: WalletType

	// MARK: - Private Variables

	private let walletManager: WalletManager

	private let store: Store

	private var sender: Sender?

	// MARK: - Public Variables

	var litewalletBalance: Double = 0.0

	var litewalletAddress: String = ""

	var cardBalance: Double = 0.0

	var cardAddress: String = ""

	var currentBalance: Double = 0.0

	var transferAmount: Double = 0.0

	/// This is the LTC address the wallet is sending LTC TO
	var destinationAddress: String {
		return walletType == .litewallet ? cardAddress : litewalletAddress
	}

	var transaction: BRTxRef?

	init(walletType: WalletType,
	     litewalletBalance: Double,
	     litewalletAddress: String,
	     cardBalance: Double,
	     cardAddress: String,
	     walletManager: WalletManager,
	     store: Store)
	{
		self.walletManager = walletManager

		self.store = store

		self.walletType = walletType

		self.litewalletBalance = litewalletBalance

		self.litewalletAddress = litewalletAddress

		// DEV: The Testnet is not implemented in Loafwallet Core.
		// This would be used for the Card testing.
		#if DEBUG
			self.litewalletAddress = MockData.testLTCAddress
		#endif

		self.cardBalance = cardBalance

		self.cardAddress = cardAddress

		currentBalance = walletType == .litewallet ? litewalletBalance : cardBalance
	}
}
