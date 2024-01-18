import UIKit

extension UIViewController {
	func addChildViewController(_ viewController: UIViewController, layout: () -> Void) {
		addChild(viewController)
		view.addSubview(viewController.view)
		layout()
		viewController.didMove(toParent: self)
	}

	func remove() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}

	func addCloseNavigationItem(tintColor: UIColor? = nil) {
		let close = UIButton.close
		close.tap = { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
		if let color = tintColor {
			close.tintColor = UIColor.black
		}
		navigationItem.leftBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: close)]
	}

	func hideCloseNavigationItem() {
		navigationItem.leftBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: UIView())]
	}
}
