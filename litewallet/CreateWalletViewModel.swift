import Foundation
import UIKit

class CreateWalletViewModel: ObservableObject {
	// MARK: - Combine Variables

	// MARK: - Public Variables

	// MARK: - Private Variables

	@Published
	var didTapIndex: Int = 0

	init() {}

	func updatePushPreference(didAcceptPush _: Bool) {}
}
