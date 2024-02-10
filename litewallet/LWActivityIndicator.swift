import Foundation
import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
	@Binding
	var isAnimating: Bool

	let style: UIActivityIndicatorView.Style

	func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView
	{
		return UIActivityIndicatorView(activityIndicatorStyle: style)
	}

	func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>)
	{
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}
