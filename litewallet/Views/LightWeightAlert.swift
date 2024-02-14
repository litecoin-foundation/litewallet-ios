import UIKit

class LightWeightAlert: UIView {
	init(message: String) {
		super.init(frame: .zero)
		label.text = message
		setup()
	}

	let effect = UIBlurEffect(style: .dark)
	let background = UIVisualEffectView()
	let container = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
	private let label = UILabel(font: .customBold(size: 16.0))

	private func setup() {
		addSubview(background)
		background.constrain(toSuperviewEdges: nil)
		background.contentView.addSubview(container)
		container.contentView.addSubview(label)
		container.constrain(toSuperviewEdges: nil)
		label.constrain(toSuperviewEdges: UIEdgeInsets(top: C.padding[2], left: C.padding[2], bottom: -C.padding[2], right: -C.padding[2]))
		layer.cornerRadius = 4.0
		layer.masksToBounds = true
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
