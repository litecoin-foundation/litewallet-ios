import Foundation

struct Localization {
	let key: String
	let value: String?
	let comment: String?
}

extension Localization {
	func localize() -> String {
		return NSLocalizedString(key,
		                         value: value ?? "#bc-ignore!",
		                         comment: comment ?? "#bc-ignore!")
	}
}
