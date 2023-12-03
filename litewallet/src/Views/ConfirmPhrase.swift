import UIKit

private let circleRadius: CGFloat = 12.0

class ConfirmPhrase: UIView {
	let word: String
	let textField = UITextField()
	var callback: (() -> Void)?
	var doneCallback: (() -> Void)?
	var isEditingCallback: (() -> Void)?

	init(text: String, word: String) {
		self.word = word
		super.init(frame: CGRect())
		translatesAutoresizingMaskIntoConstraints = false
		label.text = text
		setupSubviews()
	}

	private let label = UILabel()
	private let separator = UIView()
	private let circle = DrawableCircle()

	private func setupSubviews() {
		label.font = UIFont.customBody(size: 14.0)
		label.textColor = UIColor(white: 170.0 / 255.0, alpha: 1.0)
		separator.backgroundColor = .separatorGray

		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.font = UIFont.customBody(size: 16.0)
		textField.textColor = .darkText
		textField.delegate = self

		addSubview(label)
		addSubview(textField)
		addSubview(separator)
		addSubview(circle)

		label.constrain([
			label.constraint(.leading, toView: self, constant: C.padding[1]),
			label.constraint(.top, toView: self, constant: C.padding[1]),
		])
		textField.constrain([
			textField.constraint(.leading, toView: label, constant: nil),
			textField.constraint(toBottom: label, constant: C.padding[1] / 2.0),
			textField.constraint(.width, toView: self, constant: -C.padding[1] * 2),
		])

		separator.constrainBottomCorners(sidePadding: 0.0, bottomPadding: 0.0)
		separator.constrain([
			// This contraint to the bottom of the textField is pretty crucial. Without it,
			// this view will have an intrinsicHeight of 0
			separator.constraint(toBottom: textField, constant: C.padding[1]),
			separator.constraint(.height, constant: 1.0),
		])
		circle.constrain([
			circle.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
			circle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.padding[2]),
			circle.heightAnchor.constraint(equalToConstant: circleRadius * 2.0),
			circle.widthAnchor.constraint(equalToConstant: circleRadius * 2.0),
		])

		textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
	}

	func validate() {
		if textField.text != word {
			textField.textColor = .litecoinOrange
		}
	}

	@objc private func textFieldChanged() {
		textField.textColor = .darkText
		guard textField.markedTextRange == nil else { return }
		if textField.text == word {
			circle.show()
			textField.isEnabled = false
		}
		callback?()
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ConfirmPhrase: UITextFieldDelegate {
	func textFieldDidEndEditing(_: UITextField) {
		validate()
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.textColor = .darkText
		isEditingCallback?()
	}

	func textFieldShouldReturn(_: UITextField) -> Bool {
		if E.isIPhone4 {
			doneCallback?()
		}
		return true
	}
}
