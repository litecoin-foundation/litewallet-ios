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

/// Description: 1701029422
func tieredOpsFee(amount: UInt64) -> UInt64 {
	switch amount {
	case 0 ..< 1_398_000:
		return 69900
	case 1_398_000 ..< 6_991_000:
		return 111_910
	case 6_991_000 ..< 27_965_000:
		return 279_700
	case 27_965_000 ..< 139_820_000:
		return 699_540
	case 139_820_000 ..< 279_653_600:
		return 1_049_300
	case 279_653_600 ..< 699_220_000:
		return 1_398_800
	case 699_220_000 ..< 1_398_440_000:
		return 2_797_600
	default:
		return 2_797_600
	}
}
