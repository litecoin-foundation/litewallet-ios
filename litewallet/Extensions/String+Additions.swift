import BRCore
import FirebaseAnalytics
import Foundation
import UIKit

extension String {
	var isValidPrivateKey: Bool {
		return BRPrivKeyIsValid(self) != 0
	}

	var isValidBip38Key: Bool {
		return BRBIP38KeyIsValid(self) != 0
	}

	var isValidAddress: Bool {
		guard lengthOfBytes(using: .utf8) > 0 else { return false }
		return BRAddressIsValid(self) != 0
	}

	var sanitized: String {
		return applyingTransform(.toUnicodeName, reverse: false) ?? ""
	}

	func ltrim(_ chars: Set<Character>) -> String {
		if let index = index(where: { !chars.contains($0) }) {
			return String(self[index ..< endIndex])
		} else {
			return ""
		}
	}

	func rtrim(_ chars: Set<Character>) -> String {
		if let index = reversed().index(where: { !chars.contains($0) }) {
			return String(self[startIndex ... self.index(before: index.base)])
		} else {
			return ""
		}
	}

	func nsRange(from range: Range<Index>) -> NSRange {
		let location = utf16.distance(from: utf16.startIndex, to: range.lowerBound)
		let length = utf16.distance(from: range.lowerBound, to: range.upperBound)
		return NSRange(location: location, length: length)
	}
}

private let startTag = "<b>"
private let endTag = "</b>"

// Convert string with <b> tags to attributed string
extension String {
	var tagsRemoved: String {
		return replacingOccurrences(of: startTag, with: "").replacingOccurrences(of: endTag, with: "")
	}

	var attributedStringForTags: NSAttributedString {
		let output = NSMutableAttributedString()
		let scanner = Scanner(string: self)
		let endCount = tagsRemoved.utf8.count
		var i = 0
		while output.string.utf8.count < endCount || i < 50 {
			var regular: NSString?
			var bold: NSString?
			scanner.scanUpTo(startTag, into: &regular)
			scanner.scanUpTo(endTag, into: &bold)
			if let regular = regular {
				output.append(NSAttributedString(string: (regular as String).tagsRemoved, attributes: UIFont.regularAttributes))
			}
			if let bold = bold {
				output.append(NSAttributedString(string: (bold as String).tagsRemoved, attributes: UIFont.boldAttributes))
			}
			i += 1
		}
		return output
	}
}

// MARK: - Hex String conversions

extension String {
	var hexToData: Data? {
		let scalars = unicodeScalars
		var bytes = [UInt8](repeating: 0, count: (scalars.count + 1) >> 1)
		for (index, scalar) in scalars.enumerated() {
			guard var nibble = scalar.nibble else { return nil }
			if index & 1 == 0 {
				nibble <<= 4
			}
			bytes[index >> 1] |= nibble
		}
		return Data(bytes: bytes)
	}

	static func localizedString(for key: String,
	                            locale: Locale = .current) -> String
	{
		let language = locale.languageCode
		let path = Bundle.main.path(forResource: language, ofType: "lproj")!
		let bundle = Bundle(path: path)!
		let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

		return localizedString
	}
}

// MARK: - Language code String

extension String {
	/// 14  Languages
	/// Locale.current.identifier)
	static func preferredLanguageInterest(currentId: String) -> String {
		var codeId = ""
		if (currentId == "zh_CN") || (currentId == "zh_SG") {
			return "general-chinese-simplified"
		} else if (currentId == "zh_TW") || (currentId == "zh_HK") {
			return "general-chinese-traditional"
		} else {
			codeId = String(currentId.suffix(2))
		}

		switch codeId {
		case "en": return "general-english"
		case "fr": return "general-french"
		case "de": return "general-german"
		case "id": return "general-indonesian"
		case "it": return "general-italian"
		case "ja": return "general-japanese"
		case "ko": return "general-korean"
		case "pt": return "general-portuguese"
		case "ru": return "general-russian"
		case "es": return "general-spanish"
		case "tr": return "general-turkish"
		case "uk": return "general-ukrainian"
		default: return "general-english"
		}
	}
}

extension UnicodeScalar {
	var nibble: UInt8? {
		if value >= 48, value <= 57 {
			return UInt8(value - 48)
		} else if value >= 65, value <= 70 {
			return UInt8(value - 55)
		} else if value >= 97, value <= 102 {
			return UInt8(value - 87)
		}
		return nil
	}
}

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).uppercased() + lowercased().dropFirst()
	}

	mutating func capitalizeFirstLetter() {
		self = capitalizingFirstLetter()
	}

	func replacingZeroFeeWithTenCents() -> String {
		guard count > 3
		else {
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["ERROR": "STRING_ISSUE"])
			return self
		}

		let range = index(endIndex, offsetBy: -3) ..< endIndex
		return replacingOccurrences(of: ".00", with: ".10", options: .literal, range: range)
	}

	func combinedFeeReplacingZeroFeeWithTenCents() -> String {
		guard count > 4
		else {
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["ERROR": "STRING_ISSUE"])
			return self
		}

		let range = index(endIndex, offsetBy: -4) ..< endIndex
		return replacingOccurrences(of: ".00)", with: ".10)", options: .literal, range: range)
	}
}
