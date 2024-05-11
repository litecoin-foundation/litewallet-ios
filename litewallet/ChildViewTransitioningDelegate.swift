import UIKit

class ChildViewTransitioningDelegate: NSObject {
	// MARK: - Public

	override init() {
		super.init()
	}

	var shouldDismissInteractively = true
}

extension ChildViewTransitioningDelegate: UIViewControllerTransitioningDelegate {
	func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return nil
	}

	func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return nil
	}

	func interactionControllerForDismissal(using _: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return nil
	}
}
