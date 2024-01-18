import Foundation
import SwiftUI

class StartHostingController: UIHostingController<StartView> {
	// MARK: - Private

	var viewModel: StartViewModel

	init(store: Store, walletManager: WalletManager) {
		viewModel = StartViewModel(store: store, walletManager: walletManager)

		super.init(rootView: StartView(viewModel: viewModel))
	}

	// MARK: - Private

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
