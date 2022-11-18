import UIKit

extension UIViewControllerContextTransitioning
{
	var views: (UIView, UIView)?
	{
		guard let fromView = view(forKey: .from) else { assertionFailure("Empty from view"); return nil }
		guard let toView = view(forKey: .to) else { assertionFailure("Empty to view"); return nil }
		return (fromView, toView)
	}
}
