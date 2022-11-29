import UIKit

class RadialGradientView: UIView {
	// MARK: - Public

	init(backgroundColor: UIColor, offset: CGFloat = 0.0) {
		self.offset = offset
		super.init(frame: .zero)
		self.backgroundColor = backgroundColor
	}

	// MARK: - Private

	private let offset: CGFloat

	override func draw(_ rect: CGRect) {
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let startColor = UIColor.transparentWhite.cgColor
		let endColor = UIColor(white: 1.0, alpha: 0.0).cgColor
		let colors = [startColor, endColor] as CFArray
		let locations: [CGFloat] = [0.0, 1.0]
		guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else { return }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		let center = CGPoint(x: rect.midX, y: rect.midY + offset)
		let endRadius = rect.height
		context.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: [])
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
