import Foundation
import SwiftUI

/// As litewalletBlue view that has no real elements
class LaunchCardHostingController: UIHostingController<LaunchView> {
	var contentView = LaunchView()

	init() {
		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
