import Combine
import Foundation
import SafariServices
import SwiftUI
import UIKit
import WebKit

// inspired https://www.swiftyplace.com/blog/loading-a-web-view-in-swiftui-with-wkwebview
struct SignupWebView: UIViewRepresentable, WebViewHandlerDelegate {
	@ObservedObject
	var viewModel: SignupWebViewModel
	let url: URL

	@Binding
	var userAction: Bool

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIView(context: Context) -> WKWebView {
		let webview = SignupWebView(viewModel: SignupWebViewModel(),
		                            url: URL(string: C.signupURL)!,
		                            userAction: $userAction)

		let coordinator = makeCoordinator()

		let preferences = WKPreferences()
		preferences.javaScriptCanOpenWindowsAutomatically = true

		let configuration = WKWebViewConfiguration()
		configuration.preferences = preferences

		let source = "var meta = document.createElement('meta');" +
			"meta.name = 'viewport';" +
			"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
			"var head = document.getElementsByTagName('head')[0];" +
			"head.appendChild(meta);"

		let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		let contentController = WKUserContentController()
		configuration.userContentController = contentController
		contentController.addUserScript(script)

		let request = URLRequest(url: url)
		let wkwebView = WKWebView(frame: CGRect.zero, configuration: configuration)
		wkwebView.navigationDelegate = context.coordinator
		wkwebView.allowsBackForwardNavigationGestures = false
		wkwebView.scrollView.isScrollEnabled = false
		wkwebView.load(request)

		return wkwebView
	}

	func updateUIView(_ webview: WKWebView, context _: Context) {
		// Dismisses the keyboard
		// webview.endEditing(true)

		/// Submit Button
		webview.evaluateJavaScript("document.getElementById('submit-email').value") { result, _ in

			if let resultString = result,
			   resultString as! String == "Please Wait..."
			{
				print("::: Submitted resultString \(resultString)")
				userAction = true
			}
		}
	}

	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: SignupWebView
		var delegate: WebViewHandlerDelegate?
		var valueSubscriber: AnyCancellable?
		var webViewNavigationSubscriber: AnyCancellable?

		init(_ uiWebView: SignupWebView) {
			parent = uiWebView
			delegate = parent
		}

		deinit {
			valueSubscriber?.cancel()
			webViewNavigationSubscriber?.cancel()
		}

		// MARK: WKWebView's delegate functions

		func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
			// Hides loader
			parent.viewModel.showLoader.send(false)
		}
	}
}

// #Preview {
//    SignupWebView()
// }

//            var scriptContent = "var meta = document.createElement('meta');"
//            scriptContent += "meta.name='viewport';"
//            scriptContent += "meta.content='width=device-width';"
//            scriptContent += "meta.content = 'initial-scale=1.0, maximum-scale=1.0, user-scalable=no';"
//            scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
//            scriptContent += "document.body.scrollHeight;"

//            let source: String = "var meta = document.createElement('meta');" +
//            "meta.name = 'viewport';" +
//            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
//            "var head = document.getElementsByTagName('head')[0];" +
//            "head.appendChild(meta);"

//            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//            let userContentController: WKUserContentController = WKUserContentController()
//            let conf = WKWebViewConfiguration()
//            conf.userContentController = userContentController
//            userContentController.addUserScript(script)
//            let webView = WKWebView(frame: CGRect.zero, configuration: conf)

//            webView.evaluateJavaScript(scriptContent, completionHandler: { _, _ in
//                print("::: evaluate JS")
//            })

//
// struct TestWebView: UIViewRepresentable {
//    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
//        var webView: WKWebView?
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            self.webView = webView
//        }
//
//        // receive message from wkwebview
//        func userContentController(
//            _ userContentController: WKUserContentController,
//            didReceive message: WKScriptMessage
//        ) {
//            print(message.body)
//            let date = Date()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.messageToWebview(msg: "hello, I got your messsage: \(message.body) at \(date)")
//            }
//        }
//
//        func messageToWebview(msg: String) {
//            self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator()
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let coordinator = makeCoordinator()
//        let userContentController = WKUserContentController()
//        userContentController.add(coordinator, name: "bridge")
//
//        let configuration = WKWebViewConfiguration()
//        configuration.userContentController = userContentController
//
//        let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
//        _wkwebview.navigationDelegate = coordinator
//
//        return _wkwebview
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        guard let path: String = Bundle.main.path(forResource: "index", ofType: "html") else { return }
//        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
//        webView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
//    }
// }
