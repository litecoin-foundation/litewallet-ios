import Foundation
import KeychainAccess

class LoginViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var emailString: String = ""

	@Published
	var passwordString: String = ""

	@Published
	var tokenString: String = ""

	@Published
	var isLoggedIn: Bool = false

	@Published
	var doShowModal: Bool = false

	@Published
	var didCompleteLogin: Bool = false

	@Published
	var processMessage: String = S.LitecoinCard.login + " ..."

	// MARK: - Private Variables

	private let keychain = Keychain(service: "com.litecoincard.service")

	init()
	{}

	func simpleCredentialsCheck() -> Bool {
		return (emailString.isEmpty && passwordString.isEmpty)
	}

	func login(completion _: @escaping (Bool) -> Void) {
		// Turn on the modal
		doShowModal = false

		let credentials: [String: Any] = ["email": emailString,
		                                  "password": passwordString,
		                                  "token": tokenString]

		PartnerAPI.shared.loginUser(credentials: credentials) { _ in
//			if let error = dataDictionary {
//				DispatchQueue.main.async {
//					print("ERROR: Login failure: \(error.description)")
//
//					self.isLoggedIn = false
//					self.didCompleteLogin = false
//					completion(self.didCompleteLogin)
//				}
//			}

			LWAnalytics.logEventWithParameters(itemName: ._20210804_TAULI)

//			if let responeDict = dataDictionary,
//			   let token = responeDict["token"] as? String,
//			   let userID = responeDict["uuid"] as? String,
//			   let email = credentials["email"] as? String,
//			   let password = credentials["password"] as? String
//			{
//				self.keychain[email] = password
//				self.keychain["userID"] = userID
//				self.keychain["token"] = token
//
//				DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//					self.isLoggedIn = true
//					self.didCompleteLogin = true
//
//					// Turn modal off
//					self.doShowModal = false
//
//					NotificationCenter.default.post(name: .LitecoinCardLoginNotification, object: nil,
//					                                userInfo: nil)
//					completion(self.didCompleteLogin)
//				}
//			}
		}
	}
}
