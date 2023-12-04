import Foundation
import SwiftUI

class StartHostingController: UIHostingController<StartView> {
	var viewModel = StartViewModel(store: Store())
	let contentView = StartView()

	// MARK: - Private

	let didTapRecover: () -> Void
	let didTapCreate: () -> Void

	init(store: Store,
	     didTapCreate: @escaping () -> Void,
	     didTapRecover: @escaping () -> Void)
	{
		viewModel.store = store

		self.didTapCreate = didTapCreate
		self.didTapRecover = didTapRecover
		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
