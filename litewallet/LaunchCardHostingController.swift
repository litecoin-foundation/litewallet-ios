import Foundation
import SwiftUI

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
