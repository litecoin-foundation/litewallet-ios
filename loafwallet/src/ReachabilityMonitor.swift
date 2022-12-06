import Foundation
import SystemConfiguration

private func callback(reachability _: SCNetworkReachability, flags _: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?)
{
	guard let info = info else { return }
	let reachability = Unmanaged<ReachabilityMonitor>.fromOpaque(info).takeUnretainedValue()
	reachability.notify()
}

class ReachabilityMonitor: Trackable {
	init() {
		networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "google.com")
		start()
	}

	var didChange: ((Bool) -> Void)?

	private var networkReachability: SCNetworkReachability?
	private let reachabilitySerialQueue = DispatchQueue(label: "com.litecoin.reachabilityQueue")

	func notify() {
		DispatchQueue.main.async {
			self.didChange?(self.isReachable)
			self.saveEvent(self.isReachable ? "reachability.isReachable" : "reachability.isNotReachable")
		}
	}

	var isReachable: Bool {
		return flags.contains(.reachable)
	}

	private func start() {
		var context = SCNetworkReachabilityContext()
		context.info = UnsafeMutableRawPointer(Unmanaged<ReachabilityMonitor>.passUnretained(self).toOpaque())
		guard let reachability = networkReachability else { return }
		SCNetworkReachabilitySetCallback(reachability, callback, &context)
		SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue)
	}

	private var flags: SCNetworkReachabilityFlags {
		var flags = SCNetworkReachabilityFlags(rawValue: 0)
		if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0)) }) == true
		{
			return flags
		} else {
			return []
		}
	}
}
