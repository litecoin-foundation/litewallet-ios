import Foundation
import SwiftUI

class SendAddressHostingController: UIHostingController<SendAddressCellView> {
	var addressString: String = ""

	let contentView = SendAddressCellView()

	init() {
		addressString = contentView.viewModel.addressString
		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
