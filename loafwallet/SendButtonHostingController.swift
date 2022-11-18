import Foundation
import SwiftUI

class SendButtonHostingController: UIHostingController<SendButtonView> {
	let contentView = SendButtonView()

	init() {
		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
