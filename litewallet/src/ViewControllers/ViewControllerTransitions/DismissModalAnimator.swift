import UIKit

// TODO: - figure out who should own this
let blurView = UIVisualEffectView()

class DismissModalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.4
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard transitionContext.isAnimated else { return }
		let duration = transitionDuration(using: transitionContext)
		guard let fromView = transitionContext.view(forKey: .from) else { assertionFailure("Missing from view"); return }

		UIView.animate(withDuration: duration, animations: {
			blurView.alpha = 0.0 // Preferrably, this would animatate .effect, but it's not playing nicely with UIPercentDrivenInteractiveTransition
			fromView.frame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)
		}, completion: { _ in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
	}
}
