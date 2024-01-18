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
				print("::: signup Submitted resultString \(resultString)")
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

//
//
// class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
//    var parent: SignupWebView
//    var valueSubscriber: AnyCancellable?
//    var webViewNavigationSubscriber: AnyCancellable?
//
//    init(_ uiWebView: SignupWebView) {
//        parent = uiWebView
//    }
//
//    deinit {
//        valueSubscriber?.cancel()
//        webViewNavigationSubscriber?.cancel()
//    }
//
//    // MARK: WKWebView's delegate functions
//
//    func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError _: Error) {
//        // Hides loader
//        parent.viewModel.showLoader.send(false)
//
//        webView.evaluateJavaScript("document.getElementById('email').value") { result, error in
//            print("::: result \(result) error \(error)")
//        }
//    }
//
//    func webView(_: WKWebView, runJavaScriptAlertPanelWithMessage _: String, initiatedByFrame _: WKFrameInfo, completionHandler _: @escaping () -> Void) {
//        // alert functionality goes here
//    }
// }
//
// func makeCoordinator() -> Coordinator {
//    Coordinator(self)
// }
//
// func makeUIView(context: Context) -> WKWebView {
//    let coordinator = makeCoordinator()
//
//    let preferences = WKPreferences()
//    preferences.javaScriptEnabled = true
//
//    let configuration = WKWebViewConfiguration()
//    configuration.preferences = preferences
//
//    let contentController = WKUserContentController()
//
//    let source = "var meta = document.createElement('meta');" +
//    "meta.name = 'viewport';" +
//    "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
//    "var head = document.getElementsByTagName('head')[0];" +
//    "head.appendChild(meta);"
//
//    let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//    configuration.userContentController = contentController
//    contentController.addUserScript(script)
//
//    let wkwebView = WKWebView(frame: CGRect.zero, configuration: configuration)
//    wkwebView.navigationDelegate = context.coordinator
//    wkwebView.uiDelegate = context.coordinator
//    wkwebView.allowsBackForwardNavigationGestures = false
//    wkwebView.scrollView.isScrollEnabled = false
//    wkwebView.backgroundColor = UIColor.liteWalletDarkBlue
//
//    wkwebView.load(URLRequest(url: url))
//
//    return wkwebView
// }
//
// func updateUIView(_ webview: WKWebView, context: Context) {
//    // Dismisses the keyboard
//    // webview.endEditing(true)
//
//    webview.uiDelegate = context.coordinator
//
//    /// Submit Button
//    webview.evaluateJavaScript("document.getElementById('submit-email').value") { result, _ in
//
//        if let resultString = result as? String,
//           resultString == "Please close, and read more."
//        {
//            print("::: signup Submitted resultString \(resultString)")
//            userAction = true
//        }
//    }
//
//    webview.evaluateJavaScript("document.getElementById('email').value") { _, _ in
//    }
// }
// }

// #Preview {
//    SignupWebView()
// }
