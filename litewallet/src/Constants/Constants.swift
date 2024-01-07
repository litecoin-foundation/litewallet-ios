import UIKit

let π: CGFloat = .pi
let customUserAgent: String = "litewallet-ios"
let litecoinCardURL: String = "https://litecoin.dashboard.getblockcard.com/"
let swiftUICellPadding = 12.0
let buttonCornerRadius = 8.0
let bigButtonCornerRadius = 15.0

struct FoundationSupport {
	static let dashboard = "https://litecoinfoundation.zendesk.com/"
}

struct APIServer {
	static let baseUrl = "https://api-prod.lite-wallet.org/"
}

struct Padding {
	subscript(multiplier: Int) -> CGFloat {
		return CGFloat(multiplier) * 8.0
	}

	subscript(multiplier: Double) -> CGFloat {
		return CGFloat(multiplier) * 8.0
	}
}

struct DeviceType {
	enum Name {
		static var iPhoneSE = "iPhone SE"
		static var iPhoneSE2 = "iPhone SE2"
		static var iPhone7 = "iPhone 7"
		static var iPhone8 = "iPhone 8"
		static var iPhone8Plus = "iPhone 8+"
		static var iPhoneXSMax = "iPhone Xs Max"
		static var iPhone11ProMax = "iPhone 11 Pro Max"
		static var iPhone12Pro = "iPhone 12 Pro"
		static var iPhone12ProMax = "iPhone 12 Pro Max"
		static var iPadPro = "iPad Pro (12.9-inch) (3rd generation)"
	}
}

struct C {
	static let padding = Padding()
	struct Sizes {
		static let buttonHeight: CGFloat = 48.0
		static let sendButtonHeight: CGFloat = 65.0
		static let headerHeight: CGFloat = 48.0
		static let largeHeaderHeight: CGFloat = 220.0
		static let logoAspectRatio: CGFloat = 125.0 / 417.0
	}

	static var defaultTintColor: UIColor = UIView().tintColor

	static let animationDuration: TimeInterval = 0.3
	static let secondsInDay: TimeInterval = 86400
	static let maxMoney: UInt64 = 84_000_000 * 100_000_000
	static let satoshis: UInt64 = 100_000_000
	static let walletQueue = "com.litecoin.walletqueue"
	static let btcCurrencyCode = "LTC"
	static let null = "(null)"
	static let maxMemoLength = 250
	static let feedbackEmail = "feedback@litecoinfoundation.zendesk.com"
	static let supportEmail = "support@litecoinfoundation.zendesk.com"

	static let reviewLink = "https://itunes.apple.com/app/loafwallet-litecoin-wallet/id1119332592?action=write-review"
	static let signupURL = "https://litewallet.io/mobile-signup/signup.html"
	static let stagingSignupURL = "https://staging-litewallet-io.webflow.io/mobile-signup/signup"

	static var standardPort: Int {
		return E.isTestnet ? 19335 : 9333
	}

	static let troubleshootingQuestions = """
	    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	    <html>
	    <head>
	        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	        <style type="text/css">
	        body {
	            margin:0 0 0 0;
	            padding:0 0 0 0 !important;
	            background-color: #ffffff !important;
	            font-size:12pt;
	            font-family:'Lucida Grande',Verdana,Arial,sans-serif;
	            line-height:14px;
	            color:#303030; }
	        table td {border-collapse: collapse;}
	        td {margin:0;}
	        td img {display:block;}
	        a {color:#865827;text-decoration:underline;}
	        a:hover {text-decoration: underline;color:#865827;}
	        a img {text-decoration:none;}
	        a:visited {color: #865827;}
	        a:active {color: #865827;}
	        p {font-size: 12pt;}
	      </style>
	    </head>
	    <body>
	    <table width="400" border="0" cellpadding="5" cellspacing="5" style="margin: auto;">
	        <tr>
	            <td colspan="2" align="left" style="padding-top:7px; padding-bottom:7px; border-top: 3px solid #777; border-bottom: 1px dotted #777;">
	                <span style="font-size: 13; line-height: 16px;" face="'Lucida Grande',Verdana,Arial,sans-serif">
	                    <div>Please reply to this email with the following information so that we can prepare to help you solve your Litewallet issue.</div>
	                  <br>
	                     <div>1. What version of software running on your mobile device (e.g.; iOS 13.7 or iOS 14)?</div>
	                      <br>
	                      <br>
	                        <div>2. What version of Litewallet software is on your mobile device (found on the login view)?</div>
	                      <br>
	                      <br>
	                        <div>3. What type of iPhone do you have?</div>
	                      <br>
	                      <br>
	                        <div>4. How we can help?</div>
	                      <br>
	                      <br>
	                </span>
	            </td>
	      </tr>
	    <br>
	    </table>
	    </body>
	    </html>
	"""
}

struct AppVersion {
	static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
	static let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	static let string = "v" + versionNumber! + " (\(buildNumber!))"
}

/// False Positive Rates
/// The rate at which the requested numner of false
/// addresses are sent to the syncing node.  The more
/// fp sent the less likely that the node cannot
/// identify the Litewallet user.  Used when deploying the
/// Bloom Filter. The 3 options are from testing ideal
/// rates.
enum FalsePositiveRates: Double {
	case lowPrivacy = 0.00005
	case semiPrivate = 0.00008
	case anonymous = 0.0005
}
