import UIKit

private let duration: TimeInterval = 0.4

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate
{
	var shouldShowMaskView = true

	func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		return PresentGenericAnimator(shouldShowMaskView: shouldShowMaskView)
	}

	func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		return DismissGenericAnimator()
	}
}

class PresentGenericAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
	init(shouldShowMaskView: Bool)
	{
		self.shouldShowMaskView = shouldShowMaskView
	}

	private let shouldShowMaskView: Bool

	func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval
	{
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
	{
		let duration = transitionDuration(using: transitionContext)
		let container = transitionContext.containerView
		guard let toView = transitionContext.view(forKey: .to) else { return }
		guard let toVc = transitionContext.viewController(forKey: .to) as? ContentBoxPresenter else { return }

		let blurView = toVc.blurView
		blurView.frame = container.frame
		blurView.effect = nil
		container.addSubview(blurView)

		let fromFrame = container.frame
		let maskView = UIView(frame: CGRect(x: 0, y: fromFrame.height, width: fromFrame.width, height: 40.0))
		maskView.backgroundColor = .whiteTint
		if shouldShowMaskView
		{
			container.addSubview(maskView)
		}

		let scaleFactor: CGFloat = 0.1
		let deltaX = toVc.contentBox.frame.width * (1 - scaleFactor)
		let deltaY = toVc.contentBox.frame.height * (1 - scaleFactor)
		let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
		toVc.contentBox.transform = scale.translatedBy(x: -deltaX, y: deltaY / 2.0)

		let finalToViewFrame = toView.frame
		toView.frame = toView.frame.offsetBy(dx: 0, dy: toView.frame.height)
		container.addSubview(toView)

		UIView.spring(duration, animations: {
			maskView.frame = CGRect(x: 0, y: fromFrame.height - 30.0, width: fromFrame.width, height: 40.0)
			blurView.effect = toVc.effect
			toView.frame = finalToViewFrame
			toVc.contentBox.transform = .identity
		}, completion: { _ in
			maskView.removeFromSuperview()
			transitionContext.completeTransition(true)
		})
	}
}

class DismissGenericAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
	func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval
	{
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
	{
		let duration = transitionDuration(using: transitionContext)
		guard let fromView = transitionContext.view(forKey: .from) else { assertionFailure("Missing from view"); return }
		guard let fromVc = transitionContext.viewController(forKey: .from) as? ContentBoxPresenter else { return }

		UIView.animate(withDuration: duration, animations: {
			fromVc.blurView.effect = nil
			fromView.frame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)

			let scaleFactor: CGFloat = 0.1
			let deltaX = fromVc.contentBox.frame.width * (1 - scaleFactor)
			let deltaY = fromVc.contentBox.frame.height * (1 - scaleFactor)
			let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
			fromVc.contentBox.transform = scale.translatedBy(x: -deltaX, y: deltaY / 2.0)

		}, completion: { _ in
			transitionContext.completeTransition(true)
		})
	}
}
