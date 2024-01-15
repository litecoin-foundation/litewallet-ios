import Foundation
import SwiftUI

struct MemoFieldView: UIViewRepresentable {
	@Binding var text: String

	private var placeholder: String

	init(placeholder: String,
	     text: Binding<String>)
	{
		self.placeholder = placeholder
		_text = text
	}

	func makeUIView(context: Context) -> UITextField {
		let textfield = UITextField()
		textfield.delegate = context.coordinator
		textfield.placeholder = placeholder
		textfield.textAlignment = .left
		textfield.adjustsFontSizeToFitWidth = true
		textfield.font = UIFont.barlowMedium(size: 14.0)
		textfield.minimumFontSize = 12.0
		textfield.keyboardType = .default
		textfield.autocorrectionType = .no
		textfield.autocapitalizationType = .none
		return textfield
	}

	func updateUIView(_ uiView: UITextField, context _: Context) {
		uiView.text = text
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: MemoFieldView

		init(_ textField: MemoFieldView) {
			parent = textField
		}

		func textFieldDidEndEditing(_ textField: UITextField, reason _: UITextField.DidEndEditingReason) {
			textField.resignFirstResponder()
		}

		func textFieldDidBeginEditing(_ textField: UITextField) {
			parent.text = textField.text!
		}
	}
}
