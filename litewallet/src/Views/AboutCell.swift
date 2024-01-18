import UIKit

class AboutCell: UIView {
	let button: UIButton

	init(text: String) {
		button = UIButton.icon(image: #imageLiteral(resourceName: "OpenBrowser"), accessibilityLabel: text)
		label.text = text
		super.init(frame: .zero)

		if #available(iOS 11.0, *) {
			guard let textColor = UIColor(named: "labelTextColor")
			else {
				NSLog("ERROR: Main color")
				return
			}
			label.textColor = textColor
		}
		setup()
	}

	private var label = UILabel(font: .customBody(size: 16.0), color: .darkText)
	private let separator = UIView(color: .secondaryShadow)

	private func setup() {
		addSubview(label)
		addSubview(button)
		addSubview(separator)

		label.constrain([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.padding[2]),
			label.topAnchor.constraint(equalTo: topAnchor, constant: C.padding[2]),
			label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -C.padding[2]),
		])
		button.constrain([
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.padding[2]),
			button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
		])
		separator.constrain([
			separator.leadingAnchor.constraint(equalTo: label.leadingAnchor),
			separator.trailingAnchor.constraint(equalTo: button.trailingAnchor),
			separator.bottomAnchor.constraint(equalTo: bottomAnchor),
			separator.heightAnchor.constraint(equalToConstant: 1.0),
		])
		button.tintColor = C.defaultTintColor
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
