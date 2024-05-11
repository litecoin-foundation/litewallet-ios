import Foundation

class EnterPhraseViewModel: ObservableObject {
	// MARK: - Combine Variables

	// MARK: - Public Variables

	var store: Store
	var walletManager: WalletManager
	var reason: PhraseEntryReason

	init(store: Store,
	     walletManager: WalletManager,
	     reason: PhraseEntryReason)
	{
		self.store = store
		self.walletManager = walletManager
		self.reason = reason
	}
}
