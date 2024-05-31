import Foundation
import SwiftUI
import UIKit

// https://stackoverflow.com/questions/65297333/adding-placeholder-to-uitextview-in-swiftui-uiviewrepresentable

struct TextView: UIViewRepresentable {
	@Binding var text: String
	@Binding var didStartEditing: Bool
	private var placeholder: String

	init(text: Binding<String>,
	     didStartEditing: Binding<Bool>,
	     placeholderString: String)
	{
		_text = text
		_didStartEditing = didStartEditing
		placeholder = placeholderString
	}

	func makeUIView(context _: Context) -> UITextView {
		let textView = UITextView()
		textView.autocapitalizationType = .sentences
		textView.isSelectable = true
		textView.isUserInteractionEnabled = true
		textView.font = .customBody(size: 6.0)

		return textView
	}

	func updateUIView(_ uiView: UITextView, context _: Context) {
		if didStartEditing {
			uiView.textColor = UIColor.black
			uiView.text = text
		} else {
			uiView.text = placeholder
			uiView.textColor = UIColor.lightGray
			uiView.font = .customBody(size: 6.0)
		}

		uiView.font = UIFont.preferredFont(forTextStyle: .body)
	}
}
