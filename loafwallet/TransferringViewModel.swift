import Foundation

class TransferringViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var shouldStartTransfer: Bool = false

	init() {}

	func shouldDismissView(completion: @escaping () -> Void) {
		completion()
	}
}
