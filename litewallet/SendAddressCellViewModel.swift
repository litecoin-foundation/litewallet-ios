import Foundation

class SendAddressCellViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var addressString: String = ""

	// MARK: - Public Variables

	var shouldPasteAddress: (() -> Void)?

	var shouldScanAddress: (() -> Void)?

	init()
	{}
}
