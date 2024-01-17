import Foundation
import SwiftUI

class EnterPhraseHostingController: UIHostingController<EnterPhraseView> {
	// WIP

	//    EnterPhraseViewController(store: myself.store, walletManager: myself.walletManager, reason: .setSeed(myself.pushPinCreationViewForRecoveredWallet))

	//    private let enterPhrase: EnterPhraseCollectionViewController
	//    private let errorLabel = UILabel.wrapping(font: .customBody(size: 16.0), color: .litewalletOrange)
	//    private let instruction = UILabel(font: .customBold(size: 14.0), color: .darkText)
	//    internal let titleLabel = UILabel.wrapping(font: .customBold(size: 26.0), color: .darkText)
	//    private let subheader = UILabel.wrapping(font: .customBody(size: 16.0), color: .darkText)
	//    private let faq: UIButton
	//    private let scrollView = UIScrollView()
	//    private let container = UIView()
	//    private let moreInfoButton = UIButton(type: .system)
	//    let customTitle: String

	var contentView: EnterPhraseView
	var store: Store
	var walletManager: WalletManager
	var reason: PhraseEntryReason

	// store: myself.store, walletManager: walletManager, reason: .validateForWipingWallet

	init(store: Store, walletManager: WalletManager, reason: PhraseEntryReason) {
		// WIP
		self.store = store
		self.walletManager = walletManager
		self.reason = reason
		contentView = EnterPhraseView(viewModel: EnterPhraseViewModel(store: self.store,
		                                                              walletManager: self.walletManager,
		                                                              reason: self.reason))

		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
