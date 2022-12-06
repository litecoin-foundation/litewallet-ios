import Foundation
import LocalAuthentication

extension LAContext {
	static var canUseBiometrics: Bool {
		return LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
	}

	static var isBiometricsAvailable: Bool {
		var error: NSError?
		if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			return true
		} else {
			if error?.code == LAError.biometryNotAvailable.rawValue {
				return false
			} else {
				return true
			}
		}
	}

	static var isPasscodeEnabled: Bool {
		return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
	}

	static func biometricType() -> BiometricType {
		let context = LAContext()
		if #available(iOS 11, *) {
			_ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
			switch context.biometryType {
			case .none:
				return .none
			case .touchID:
				return .touch
			case .faceID:
				return .face
			}
		} else {
			return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
		}
	}

	enum BiometricType {
		case none
		case touch
		case face
	}
}
