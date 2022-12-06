import Foundation

class RetryTimer {
	var callback: (() -> Void)?
	private var timer: Timer?
	private var fibA: TimeInterval = 0.0
	private var fibB: TimeInterval = 1.0

	func start() {
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(retry), userInfo: nil, repeats: false)
	}

	func stop() {
		timer?.invalidate()
	}

	@objc private func retry() {
		callback?()
		timer?.invalidate()
		let newInterval = fibA + fibB
		fibA = fibB
		fibB = newInterval
		timer = Timer.scheduledTimer(timeInterval: newInterval, target: self, selector: #selector(retry), userInfo: nil, repeats: false)
	}
}
