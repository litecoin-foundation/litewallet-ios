import Foundation
import SwiftUI

class StartHostingController: UIHostingController<StartView> {
	var viewModel = StartViewModel(store: Store())
	let contentView = StartView()

	// MARK: - Private

	init(store: Store) {
		viewModel.store = store
		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
