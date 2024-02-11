import SwiftUI
import UIKit

extension UIFont {
	static var header: UIFont {
		return UIFont(name: "BarlowSemiCondensed-Bold", size: 17.0) ?? UIFont.preferredFont(forTextStyle: .headline)
	}

	static func customBold(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Bold", size: size) ?? UIFont.preferredFont(forTextStyle: .headline)
	}

	static func customBody(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Regular", size: size) ?? UIFont.preferredFont(forTextStyle: .subheadline)
	}

	static func customMedium(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Medium", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static func barlowBold(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Bold", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static func barlowSemiBold(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-SemiBold", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static func barlowItalic(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Italic", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static func barlowMedium(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Medium", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static func barlowRegular(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Regular", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static func barlowLight(size: CGFloat) -> UIFont {
		return UIFont(name: "BarlowSemiCondensed-Light", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
	}

	static var regularAttributes: [NSAttributedString.Key: Any] {
		return [
			.font: UIFont.customBody(size: 14.0),
			.foregroundColor: UIColor.darkText,
		]
	}

	static var boldAttributes: [NSAttributedString.Key: Any] {
		return [
			.font: UIFont.customBold(size: 14.0),
			.foregroundColor: UIColor.darkText,
		]
	}
}

extension Font {
	static func barlowSemiBold(size: CGFloat) -> Font {
		return Font.custom("BarlowSemiCondensed-SemiBold", size: size)
	}

	static func barlowBold(size: CGFloat) -> Font {
		return Font.custom("BarlowSemiCondensed-Bold", size: size)
	}

	static func barlowItalic(size: CGFloat) -> Font {
		return Font.custom("BarlowSemiCondensed-Italic", size: size)
	}

	static func barlowMedium(size: CGFloat) -> Font {
		return Font.custom("BarlowSemiCondensed-Medium", size: size)
	}

	static func barlowRegular(size: CGFloat) -> Font {
		return Font.custom("BarlowSemiCondensed-Regular", size: size)
	}

	static func barlowLight(size: CGFloat) -> Font {
		return Font.custom("BarlowSemiCondensed-Light", size: size)
	}
}
