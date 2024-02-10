import UIKit

struct KeyboardNotificationInfo {
	let endFrame: CGRect

	let startFrame: CGRect

	var deltaY: CGFloat {
		return endFrame.minY - startFrame.minY
	}

	var animationOptions: UIView.AnimationOptions {
		return UIView.AnimationOptions(rawValue: animationCurve << 16)
	}

	let animationDuration: Double

	init?(_ userInfo: [AnyHashable: Any]?) {
		guard let userInfo = userInfo else { return nil }
		guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
		      let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
		      let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
		      let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
		else {
			return nil
		}

		self.endFrame = endFrame.cgRectValue
		self.startFrame = startFrame.cgRectValue
		self.animationDuration = animationDuration.doubleValue
		self.animationCurve = animationCurve.uintValue
	}
	private let animationCurve: UInt
}
