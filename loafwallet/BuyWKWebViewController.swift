import SafariServices
import UIKit
import WebKit

class BuyWKWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
	@IBOutlet var backbutton: UIButton!
	@IBOutlet var wkWebContainerView: UIView!
	@IBOutlet var backButton: UIButton!
	@IBOutlet var currentAddressButton: UIButton!
	@IBOutlet var copiedLabel: UILabel!

	var didDismissChildView: (() -> Void)?

	var uuidString: String = ""

	var currentWalletAddress: String = ""

	var timestamp: Int = 0

	var appInstallDate: Date = .init()

	private let wkProcessPool = WKProcessPool()

	var currencyCode: String = "USD"

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubViews()
		loadSimplexRequest()
	}

	private func setupSubViews() {
		currentAddressButton.setTitle(currentWalletAddress, for: .normal)
		currentAddressButton.setTitle("Copied", for: .selected)
		copiedLabel.text = ""
		copiedLabel.alpha = 0.0
	}

	func loadSimplexRequest() {
		let urlString: String = APIServer.baseUrl + "?address=\(currentWalletAddress)&code=\(currencyCode)&idate=\(timestamp)&uid=\(uuidString)"

		guard let url = URL(string: urlString)
		else {
			NSLog("ERROR: URL not initialized")
			return
		}

		let request = URLRequest(url: url)

		let contentController = WKUserContentController()
		contentController.add(self, name: "callback")

		let config = WKWebViewConfiguration()
		config.processPool = wkProcessPool
		config.userContentController = contentController

		let wkWithFooter = CGRect(x: 0, y: 0, width: wkWebContainerView.bounds.width,
		                          height: wkWebContainerView.bounds.height - 100)
		let setupWkWebView = WKWebView(frame: wkWithFooter, configuration: config)
		setupWkWebView.navigationDelegate = self
		setupWkWebView.allowsBackForwardNavigationGestures = true
		setupWkWebView.contentMode = .scaleAspectFit
		setupWkWebView.autoresizesSubviews = true
		setupWkWebView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		wkWebContainerView.addSubview(setupWkWebView)
		setupWkWebView.load(request)
	}

	@IBAction func didTapCurrentAddressButton(_: Any) {
		UIPasteboard.general.string = currentWalletAddress
		copiedLabel.alpha = 1
		copiedLabel.text = S.Receive.copied
		UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseInOut, animations: {
			self.copiedLabel.alpha = 0.0
		}, completion: nil)
	}

	@IBAction func backAction(_: Any) {
		didDismissChildView?()
	}
}

extension BuyWKWebViewController {
	// MARK: - WK Navigation Delegate

	open func webView(_: WKWebView, decidePolicyFor _: WKNavigationAction,
	                  decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
	{
		return decisionHandler(.allow)
	}

	func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
		webView.evaluateJavaScript("document.readyState", completionHandler: { complete, _ in
			if complete != nil {}
		})
	}

	func userContentController(_: WKUserContentController,
	                           didReceive _: WKScriptMessage) {}
}
