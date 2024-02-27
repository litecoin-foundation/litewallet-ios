import UIKit

func guardProtected(queue: DispatchQueue, callback: @escaping () -> Void) {
	DispatchQueue.main.async {
		if UIApplication.shared.isProtectedDataAvailable {
			callback()
		} else {
			var observer: Any?
			observer = NotificationCenter
				.default
				.addObserver(forName: UIApplication.protectedDataDidBecomeAvailableNotification,
				             object: nil,
				             queue: nil,
				             using: { _ in
				             	queue.async {
				             		callback()
				             	}
				             	if let observer = observer {
				             		NotificationCenter.default.removeObserver(observer)
				             	}
				             })
		}
	}
}

func strongify<Context: AnyObject>(_ context: Context, closure: @escaping (Context) -> Void) -> () -> Void
{
	return { [weak context] in
		guard let strongContext = context else { return }
		closure(strongContext)
	}
}

func strongify<Context: AnyObject, Arguments>(_ context: Context?, closure: @escaping (Context, Arguments) -> Void) -> (Arguments) -> Void
{
	return { [weak context] arguments in
		guard let strongContext = context else { return }
		closure(strongContext, arguments)
	}
}

/// Description: 1707828867
func tieredOpsFee(amount: UInt64) -> UInt64 {
	switch amount {
	case 0 ..< 250_000_000:
		return 350_000
	case 250_000_000 ..< 1_000_000_000:
		return 1_500_000
	case _ where amount > 1_000_000_000:
		return 3_500_000
	default:
		return 3_500_000
	}
}
