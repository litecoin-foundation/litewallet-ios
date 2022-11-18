import Foundation

class TransactionsViewModel: ObservableObject
{
	var store: Store

	var walletManager: WalletManager

	var isLTCSwapped: Bool = false

	init(store: Store, walletManager: WalletManager)
	{
		self.store = store
		self.walletManager = walletManager
		isLTCSwapped = store.state.isLtcSwapped
	}
}
