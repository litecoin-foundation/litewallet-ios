import Foundation
import WebKit

class CardWebViewController: UIViewController {
	var webView: WKWebView!

	override func loadView() {
		guard let url = URL(string: litecoinCardURL) else { return }

		let request = URLRequest(url: url)

		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.navigationDelegate = self
		webView.load(request)
		view = webView
	}
}

extension CardWebViewController: WKNavigationDelegate {
	func webView(_: WKWebView, didCommit _: WKNavigation!) {}

	func webView(_: WKWebView, didFinish _: WKNavigation!) {}

	func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {}
}
