import UIKit

enum MenuButtonType {
	case security
	case customerSupport
	case settings
	case lock

	var title: String {
		switch self {
		case .security:
			return S.MenuButton.security.localize()
		case .customerSupport:
			return S.MenuButton.support.localize()
		case .settings:
			return S.MenuButton.settings.localize()
		case .lock:
			return S.MenuButton.lock.localize()
		}
	}

	var image: UIImage {
		switch self {
		case .security:
			return #imageLiteral(resourceName: "Shield")
		case .customerSupport:
			return #imageLiteral(resourceName: "FaqFill")
		case .settings:
			return #imageLiteral(resourceName: "Settings")
		case .lock:
			return #imageLiteral(resourceName: "Lock")
		}
	}
}
