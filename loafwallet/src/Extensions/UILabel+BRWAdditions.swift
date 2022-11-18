import UIKit

extension UILabel
{
	static func wrapping(font: UIFont, color: UIColor) -> UILabel
	{
		let label = UILabel()
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = font
		label.textColor = color
		return label
	}

	static func wrapping(font: UIFont) -> UILabel
	{
		let label = UILabel()
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = font
		return label
	}

	convenience init(font: UIFont)
	{
		self.init()
		self.font = font
	}

	convenience init(font: UIFont, color: UIColor)
	{
		self.init()
		self.font = font
		textColor = color
	}

	func pushNewText(_ newText: String)
	{
		let animation = CATransition()
		animation.timingFunction = CAMediaTimingFunction(name:
			kCAMediaTimingFunctionEaseInEaseOut)
		animation.type = kCATransitionPush
		animation.subtype = kCATransitionFromTop
		animation.duration = C.animationDuration
		layer.add(animation, forKey: kCATransitionPush)
		text = newText
	}
}
