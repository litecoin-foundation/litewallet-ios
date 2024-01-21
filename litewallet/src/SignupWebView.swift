import Combine
import Foundation
import SafariServices
import SwiftUI
import UIKit
import WebKit

struct SignupWebView: UIViewRepresentable {
	@Binding
	var userAction: Bool

	let urlString: String

	private var webView: WKWebView?

	init(userAction: Binding<Bool>, urlString: String) {
		webView = WKWebView()
		self.urlString = urlString
		_userAction = userAction
	}

	func makeUIView(context: Context) -> WKWebView {
		let source = "var meta = document.createElement('meta');" +
			"meta.name = 'viewport';" +
			"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
			"var head = document.getElementsByTagName('head')[0];" +
			"head.appendChild(meta);"

		let script = WKUserScript(source: source,
		                          injectionTime: .atDocumentEnd,
		                          forMainFrameOnly: true)

		let userContentController = WKUserContentController()
		userContentController.addUserScript(script)

		let configuration = WKWebViewConfiguration()
		configuration.userContentController = userContentController

		let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
		_wkwebview.navigationDelegate = context.coordinator
		_wkwebview.uiDelegate = context.coordinator
		_wkwebview.allowsBackForwardNavigationGestures = false
		_wkwebview.scrollView.isScrollEnabled = false
		_wkwebview.backgroundColor = UIColor.liteWalletDarkBlue
		_wkwebview.load(URLRequest(url: URL(string: urlString)!))

		return _wkwebview
	}

	func updateUIView(_ webView: WKWebView, context _: Context) {
		webView.evaluateJavaScript("document.getElementById('submit-email').value") { response, _ in

			if let resultString = response as? String,
			   resultString.contains("Please")
			{
				userAction = true

				let signupDict: [String: String] = ["date_accepted": Date().ISO8601Format()]
				LWAnalytics.logEventWithParameters(itemName: ._20240101_US, properties: signupDict)
			}
		}
	}

	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}

	class Coordinator: NSObject,
		WKNavigationDelegate,
		WKUIDelegate,
		WKScriptMessageHandler
	{
		func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
			print("::: message \(message)")
		}

		let parent: SignupWebView

		init(_ parent: SignupWebView) {
			self.parent = parent
		}
	}
}
