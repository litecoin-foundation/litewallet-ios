import Foundation
import SafariServices
import SwiftUI
import UIKit
import WebKit

// inspired https://www.swiftyplace.com/blog/loading-a-web-view-in-swiftui-with-wkwebview

struct WebView: UIViewRepresentable {
	let url: URL
	@Binding
	var scrollToSignup: Bool

	@State
	private
	var didStartEditing: Bool = false

	func makeUIView(context _: Context) -> WKWebView {
		let webview = SignupWebView(frame: CGRectZero, didStartEditing: $didStartEditing)
		let request = URLRequest(url: url)
		webview.load(request)
		return webview
	}

	func updateUIView(_ webview: WKWebView, context _: Context) {
		webview.endEditing(true)

		if scrollToSignup {
			let point = CGPoint(x: 0, y: webview.scrollView.contentSize.height - webview.frame.size.height / 2)

			webview.scrollView.setContentOffset(point, animated: true)
			DispatchQueue.main.async {
				self.scrollToSignup = false
			}
		}
	}
}

// https://stackoverflow.com/questions/44684714/show-keyboard-on-button-click-by-calling-wkwebview-input-field
class SignupWebView: WKWebView, WKNavigationDelegate {
	@Binding
	var didStartEditing: Bool

	init(frame: CGRect, didStartEditing: Binding<Bool>) {
		_didStartEditing = didStartEditing

		let configuration = WKWebViewConfiguration()
		super.init(frame: frame, configuration: configuration)
		navigationDelegate = self
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var intrinsicContentSize: CGSize {
		return scrollView.contentSize
	}

	func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
		var scriptContent = "var meta = document.createElement('meta');"
		scriptContent += "meta.name='viewport';"
		scriptContent += "meta.content='width=device-width';"
		scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
		scriptContent += "document.body.scrollHeight;"

		webView.evaluateJavaScript(scriptContent, completionHandler: { height, error in

			debugPrint(height ?? 0.0)
			debugPrint(error)
		})

		webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value: Any!, error: Error!) in
			if error != nil {
				// Error logic
				return
			}

			debugPrint(value ?? "Empty string")
		})
	}
}
