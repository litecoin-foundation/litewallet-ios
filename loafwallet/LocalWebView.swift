import Combine
import Foundation
import SwiftUI
import UIKit
import WebKit

// MARK: - WebViewHandlerDelegate

protocol WebViewHandlerDelegate
{}

struct LocalWebView: UIViewRepresentable, WebViewHandlerDelegate {
	@ObservedObject
	var viewModel: LocalWebViewModel

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIView(context: Context) -> WKWebView {
		let preferences = WKPreferences()
		preferences.javaScriptCanOpenWindowsAutomatically = true

		let configuration = WKWebViewConfiguration()
		configuration.preferences = preferences

		let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
		webView.navigationDelegate = context.coordinator
		webView.allowsBackForwardNavigationGestures = false
		webView.scrollView.isScrollEnabled = true
		return webView
	}

	func updateUIView(_ webView: WKWebView, context _: Context) {
		if let url = Bundle.main.url(forResource: "bitrefill_index", withExtension: "html") {
			webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
		} else {
			NSLog("ERROR: Local html not found")
		}
	}

	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: LocalWebView
		var delegate: WebViewHandlerDelegate?
		var valueSubscriber: AnyCancellable?
		var webViewNavigationSubscriber: AnyCancellable?

		init(_ uiWebView: LocalWebView) {
			parent = uiWebView
			delegate = parent
		}

		deinit {
			valueSubscriber?.cancel()
			webViewNavigationSubscriber?.cancel()
		}

		func webView(_: WKWebView, didFinish _: WKNavigation!) {
			parent.viewModel.showLoader.send(false)
		}

		// MARK: WKWebView's delegate functions

		func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
			// Hides loader
			parent.viewModel.showLoader.send(false)
		}

		func webView(_: WKWebView, didCommit _: WKNavigation!) {
			// Shows loader
			parent.viewModel.showLoader.send(true)
		}

		func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
			// Shows loader
			parent.viewModel.showLoader.send(true)
		}
	}
}

// MARK: - Extensions

extension LocalWebView.Coordinator: WKScriptMessageHandler {
	func userContentController(_: WKUserContentController,
	                           didReceive _: WKScriptMessage)
	{}
}
