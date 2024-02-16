import Foundation
import SwiftUI
import UIKit

struct PINFieldView: UIViewRepresentable {
	// MARK: - Combine Variables

	@Binding
	var pinText: String

	@Binding
	var pinIsFilled: Bool

	@Binding
	var viewRect: CGRect

	// MARK: - Public Variables

	public
	var isFirstResponder: Bool = false

	public
	var placeholder: String = "------"

	// MARK: - Private Variables

	private
	let viewKerning: CGFloat = 10.0

	private
	let maxPinDigits: Int = 6

	init(pinText: Binding<String>,
	     pinIsFilled: Binding<Bool>,
	     viewRect: Binding<CGRect>)
	{
		_pinText = pinText
		_pinIsFilled = pinIsFilled
		_viewRect = viewRect
	}

	func makeUIView(context: UIViewRepresentableContext<PINFieldView>) -> UITextField {
		let textField = UITextField()
		textField.delegate = context.coordinator
		textField.font = .barlowSemiBold(size: 24.0)
		textField.textAlignment = .center
		textField.backgroundColor = .clear
		textField.textColor = UIColor(Color.liteWalletDarkBlue)
		textField.defaultTextAttributes.updateValue(viewKerning, forKey: NSAttributedString.Key.kern)
		textField.keyboardType = .decimalPad
		textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
			NSAttributedString.Key.kern: 15.0,
			NSAttributedString.Key.foregroundColor: UIColor(Color.green),
			NSAttributedString.Key.font: UIFont.barlowBold(size: 17.0),
		])
		viewRect = textField.bounds
		return textField
	}

	func updateUIView(_: UITextField, context _: UIViewRepresentableContext<PINFieldView>) {}

	func makeCoordinator() -> PINFieldView.Coordinator {
		Coordinator(parent: self)
	}

	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: PINFieldView

		init(parent: PINFieldView) {
			self.parent = parent
		}

		func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
			let maxLength = parent.maxPinDigits
			let currentString: NSString = (textField.text ?? "") as NSString
			let newString: NSString =
				currentString.replacingCharacters(in: range, with: string) as NSString

			if newString.length == parent.maxPinDigits {
				parent.pinText = String(newString)
				parent.pinIsFilled = true
			} else {
				parent.pinIsFilled = false
			}

			return newString.length <= maxLength
		}

		func textFieldDidEndEditing(_ textField: UITextField) {
			textField.resignFirstResponder()
		}
	}
}

struct PINFieldView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			HStack {
				PINFieldView(pinText: .constant(""),
				             pinIsFilled: .constant(true),
				             viewRect: .constant(CGRect()))
			}
		}
	}
}
