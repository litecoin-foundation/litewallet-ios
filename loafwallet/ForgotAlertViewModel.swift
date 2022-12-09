import Foundation
import SwiftUI

class ForgotAlertViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var emailString: String = ""

	@Published
	var detailMessage: String = S.LitecoinCard.resetPasswordDetail

	init() {}

	func resetPassword(completion _: @escaping () -> Void) {
//		PartnerAPI.shared.forgotPassword(email: emailString) { responseMessage in
//			DispatchQueue.main.async {
//				self.detailMessage = responseMessage
//				completion()
//			}
//		}
	}

	func shouldDismissView(completion: @escaping () -> Void) {
		completion()
	}
}
