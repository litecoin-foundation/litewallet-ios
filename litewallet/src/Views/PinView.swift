import UIKit

enum PinViewStyle {
	case create
	case login
}

class PinView: UIView {
	// MARK: - Public

	var itemSize: CGFloat {
		switch style {
		case .create:
			return 24.0
		case .login:
			return 16.0
		}
	}

	var width: CGFloat {
		return (itemSize + C.padding[1]) * CGFloat(length)
	}

	let shakeDuration: CFTimeInterval = 0.6
	fileprivate var shakeCompletion: (() -> Void)?

	init(style: PinViewStyle, length: Int) {
		self.style = style
		self.length = length
		switch style {
		case .create:
			unFilled = (0 ... (length - 1)).map { _ in Circle(color: .transparentWhite) }
		case .login:
			unFilled = (0 ... (length - 1)).map { _ in Circle(color: .transparentWhite) }
		}
		filled = (0 ... (length - 1)).map { _ in Circle(color: .white) }
		super.init(frame: CGRect())
		setupSubviews()
	}

	func fill(_ number: Int) {
		filled.enumerated().forEach { index, circle in
			circle.isHidden = index > number - 1
		}
	}

	func shake(completion: (() -> Void)? = nil) {
		shakeCompletion = completion
		let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

		let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.y")
		rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

		rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
			self.toRadian(value: $0)
		}
		let shakeGroup = CAAnimationGroup()
		shakeGroup.animations = [translation, rotation]
		shakeGroup.duration = shakeDuration
		shakeGroup.delegate = self
		layer.add(shakeGroup, forKey: "shakeIt")
	}

	// MARK: - Private

	private let unFilled: [Circle]
	private var filled: [Circle]
	private let style: PinViewStyle
	private let length: Int

	private func toRadian(value: Int) -> CGFloat {
		return CGFloat(Double(value) / 180.0 * .pi)
	}

	private func setupSubviews() {
		addCircleContraints(unFilled)
		addCircleContraints(filled)
		filled.forEach { $0.isHidden = true }
	}

	private func addCircleContraints(_ circles: [Circle]) {
		circles.enumerated().forEach { index, circle in
			addSubview(circle)
			let leadingConstraint: NSLayoutConstraint?
			if index == 0 {
				leadingConstraint = circle.constraint(.leading, toView: self, constant: 0.0)
			} else {
				leadingConstraint = NSLayoutConstraint(item: circle, attribute: .leading, relatedBy: .equal, toItem: circles[index - 1], attribute: .trailing, multiplier: 1.0, constant: 8.0)
			}
			circle.constrain([
				circle.constraint(.width, constant: itemSize),
				circle.constraint(.height, constant: itemSize),
				circle.constraint(.centerY, toView: self, constant: nil),
				leadingConstraint,
			])
		}
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension PinView: CAAnimationDelegate {
	func animationDidStop(_: CAAnimation, finished _: Bool) {
		shakeCompletion?()
	}
}
