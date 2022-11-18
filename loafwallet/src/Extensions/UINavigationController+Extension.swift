import SwiftUI
import UIKit

extension UINavigationController {
	override open func viewDidLoad() {
		super.viewDidLoad()
	}

	func setDefaultStyle() {
		setClearNavbar()
		setBlackBackArrow()
	}

	func setWhiteStyle() {
		navigationBar.tintColor = .white
		navigationBar.titleTextAttributes = [
			NSAttributedStringKey.foregroundColor: UIColor.white,
			NSAttributedStringKey.font: UIFont.customBold(size: 17.0),
		]
		setTintableBackArrow()
	}

	func setClearNavbar() {
		navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationBar.shadowImage = UIImage()
		navigationBar.isTranslucent = true
	}

	func setNormalNavbar() {
		navigationBar.setBackgroundImage(nil, for: .default)
		navigationBar.shadowImage = nil
	}

	func setBlackBackArrow() {
		let image = #imageLiteral(resourceName: "Back")
		let renderedImage = image.withRenderingMode(.alwaysOriginal)
		navigationBar.backIndicatorImage = renderedImage
		navigationBar.backIndicatorTransitionMaskImage = renderedImage
	}

	func setTintableBackArrow() {
		navigationBar.backIndicatorImage = #imageLiteral(resourceName: "Back")
		navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "Back")
	}
}
