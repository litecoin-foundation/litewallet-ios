import Foundation
import UnstoppableDomainsResolution

struct DomainResolutionFailure {
	init() {}

	func messageWith(error: ResolutionError) -> String {
		switch error {
		case .unregisteredDomain, .unsupportedDomain,
		     .recordNotFound, .recordNotSupported,
		     .unspecifiedResolver:
			return String(format: S.Send.UnstoppableDomains.lookupDomainError.localize(), 0)
		default:
			return String(format: S.Send.UnstoppableDomains.udSystemError.localize(), 10)
		}
	}
}
