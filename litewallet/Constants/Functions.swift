import BRCore
import Foundation
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

/// Description: 1709405141
func tieredOpsFee(store: Store, amount: UInt64) -> UInt64 {
	var usdRate = 67.000
	if let liveRate = store.state.rates.filter({ $0.code == "USD" }).first?.rate {
		usdRate = liveRate
	}
	let usdInLTC = Double(amount) * usdRate / 100_000_000

	switch usdInLTC {
	case 0 ..< 20.00:
		return UInt64(0.20 / usdRate * 100_000_000)
	case 20.00 ..< 50.00:
		return UInt64(0.30 / usdRate * 100_000_000)
	case 50.00 ..< 100.00:
		return UInt64(1.00 / usdRate * 100_000_000)
	case 100.00 ..< 500.00:
		return UInt64(2.00 / usdRate * 100_000_000)
	case 500.00 ..< 1000.00:
		return UInt64(2.50 / usdRate * 100_000_000)
	case _ where usdInLTC > 1000.00:
		return UInt64(3.00 / usdRate * 100_000_000)
	default:
		return UInt64(3.00 / usdRate * 100_000_000)

	}
}
