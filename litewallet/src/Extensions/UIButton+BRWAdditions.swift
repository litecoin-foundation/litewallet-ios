import UIKit

extension UIButton {
	static func vertical(title: String, image: UIImage) -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle(title, for: .normal)
		button.setImage(image, for: .normal)
		button.titleLabel?.font = UIFont.customMedium(size: 11.0)
		if let imageSize = button.imageView?.image?.size,
		   let font = button.titleLabel?.font
		{
			let spacing: CGFloat = C.padding[1] / 2.0
			let titleSize = NSString(string: title).size(withAttributes: [NSAttributedString.Key.font: font])

			// These edge insets place the image vertically above the title label
			button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
			button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
		}
		return button
	}

	static var close: UIButton {
		let accessibilityLabel = E.isScreenshots ? "Close" : S.AccessibilityLabels.close.localize()
		return UIButton.icon(image: #imageLiteral(resourceName: "Close"), accessibilityLabel: accessibilityLabel)
	}

	static func buildFaqButton(store: Store, articleId: String) -> UIButton {
		let button = UIButton.icon(image: #imageLiteral(resourceName: "Faq"), accessibilityLabel: S.AccessibilityLabels.faq.localize())
		button.tap = {
			store.trigger(name: .presentFaq(articleId))
		}
		return button
	}

	static func icon(image: UIImage, accessibilityLabel: String) -> UIButton {
		let button = UIButton(type: .system)
		button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
		button.setImage(image, for: .normal)

		if image == #imageLiteral(resourceName: "Close") {
			button.imageEdgeInsets = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 14.0, right: 14.0)
		} else {
			button.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
		}

		button.tintColor = .darkText
		button.accessibilityLabel = accessibilityLabel
		return button
	}

	func tempDisable() {
		isEnabled = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
			self?.isEnabled = true
		}
	}

	static func stylizeLitewalletBlueButton(title: String, frame: CGRect) -> UIButton {
		let button = UIButton()
		button.frame = frame
		button.setTitle(title, for: .normal)
		button.layer.cornerRadius = 4.0
		button.titleLabel?.textColor = .white
		button.titleLabel?.font = UIFont.barlowMedium(size: 18)
		button.clipsToBounds = true
		return button
	}
}
