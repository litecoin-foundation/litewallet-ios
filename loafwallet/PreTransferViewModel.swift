import Foundation
import SwiftUI

class PreTransferViewModel: ObservableObject {
	// MARK: - Public Parameters

	var walletType: WalletType

	var balance: Double

	init(walletType: WalletType, balance: Double) {
		self.walletType = walletType

		self.balance = balance
	}
}
