import Foundation

class SendAddressCellViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var addressString: String = ""

	@Published
	var amountString: String = ""

	@Published
	var didUpdatePaste: Bool = false

	// MARK: - Public Variables

	var shouldPasteAddress: (() -> Void)?

	var shouldScanAddress: (() -> Void)?

	var balanceTextForAmount: ((Satoshis?, Rate?) -> (NSAttributedString?, NSAttributedString?)?)?
	var didUpdateAmount: ((Satoshis?) -> Void)?
	var didChangeFirstResponder: ((Bool) -> Void)?
	var didShowFiat: ((_ isShowingFiat: Bool) -> Void)?

	init()
	{}
}
