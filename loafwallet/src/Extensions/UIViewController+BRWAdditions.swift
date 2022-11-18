import UIKit

extension UIViewController
{
	func addChildViewController(_ viewController: UIViewController, layout: () -> Void)
	{
		addChildViewController(viewController)
		view.addSubview(viewController.view)
		layout()
		viewController.didMove(toParentViewController: self)
	}

	func remove()
	{
		willMove(toParentViewController: nil)
		view.removeFromSuperview()
		removeFromParentViewController()
	}

	func addCloseNavigationItem(tintColor: UIColor? = nil)
	{
		let close = UIButton.close
		close.tap = { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
		if let color = tintColor
		{
			if #available(iOS 11.0, *),
			   let labelTextColor = UIColor(named: "labelTextColor")
			{
				close.tintColor = labelTextColor
			}
			else
			{
				close.tintColor = color
			}
		}
		navigationItem.leftBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: close)]
	}

	func hideCloseNavigationItem()
	{
		navigationItem.leftBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: UIView())]
	}
}
