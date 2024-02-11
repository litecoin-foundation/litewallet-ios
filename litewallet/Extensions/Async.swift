import Foundation

enum Async {
	static func parallel(callbacks: [(@escaping () -> Void) -> Void], completion: @escaping () -> Void)
	{
		let dispatchGroup = DispatchGroup()
		callbacks.forEach { cb in
			dispatchGroup.enter()
			cb {
				dispatchGroup.leave()
			}
		}
		dispatchGroup.notify(queue: .main) {
			completion()
		}
	}
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
		Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
