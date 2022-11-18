import Foundation
import KeychainAccess
import SwiftUI

class Enter2FACodeViewModel: ObservableObject
{
	// Description:
	// The setter is used to make sure the field has only 6 digits
	let characterLimit: Int

	@Published var tokenString = ""
	{
		didSet
		{
			if tokenString.count > characterLimit,
			   oldValue.count <= characterLimit
			{
				tokenString = oldValue
			}
		}
	}

	@Published
	var didSetToken: Bool = false

	init(limit: Int = 6)
	{
		characterLimit = limit
	}

	func shouldDismissView(completion: @escaping () -> Void)
	{
		completion()
	}

	func didConfirmToken(completion: @escaping (String) -> Void)
	{
		completion(tokenString)
	}
}
