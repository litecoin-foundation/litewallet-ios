import UIKit

let π: CGFloat = .pi
let customUserAgent: String = "litewallet-ios"
let swiftUICellPadding = 12.0
let bigButtonCornerRadius = 15.0

struct FoundationSupport {
	static let dashboard = "https://support.litewallet.io/"
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

struct C {
	static let padding = Padding()
	struct Sizes {
		static let buttonHeight: CGFloat = 48.0
		static let sendButtonHeight: CGFloat = 165.0
		static let headerHeight: CGFloat = 48.0
		static let largeHeaderHeight: CGFloat = 220.0
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

enum LWBGTaskidentifier: String {
	case fetch = "com.litecoin.fetchLitewallet"
	case backup = "com.litecoin.backupLitewallet"
}

/// Custom Event Enum: Events related to different user based actions
enum CustomEvent: String {
	/// App Launched
	case _20191105_AL = "app_launched"

	/// Visit Receive Controller
	case _20202116_VRC = "visited_received_controller"

	/// Visit Send Controller
	case _20191105_VSC = "visited_send_controller"

	/// Did Tap Buy Tab Controller
	case _20191105_DTBT = "did_tap_buy_tab"

	/// Did Send LTC
	case _20191105_DSL = "did_send_ltc"

	/// Did Tap Support
	case _20201118_DTS = "did_tap_support"

	/// Entered dispatch group
	case _20200111_DEDG = "did_enter_dispatch_group"

	/// Left dispatch group
	case _20200111_DLDG = "did_leave_dispatch_group"

	/// Rate not initialized
	case _20200111_RNI = "rate_not_initialized"

	/// Fee per kb not initialized
	case _20200111_FNI = "feeperkb_not_initialized"

	/// Transaction not initialized
	case _20200111_TNI = "transaction_not_initialized"

	/// Wallet not initialized
	case _20200111_WNI = "wallet_not_initialized"

	/// Phrase not initialized
	case _20200111_PNI = "phrase_not_initialized"

	/// Unable to sign transaction
	case _20200111_UTST = "unable_to_sign_transaction"

	/// Generalized Error
	case _20200112_ERR = "error"

	/// Keychain Lookup
	case _20210804_ERR_KLF = "error_key_lookup_failure"

	/// Started resync
	case _20200112_DSR = "did_start_resync"

	/// Showed review request
	case _20200125_DSRR = "did_show_review_request"

	/// Unlocked in with PIN
	case _20200217_DUWP = "did_unlock_with_pin"

	/// App Launched
	case _20200217_DUWB = "did_unlock_with_biometrics"

	/// Did use default fee per kb
	case _20200301_DUDFPK = "did_use_default_fee_per_kb"

	/// User tapped support LF
	case _20201118_DTGS = "did_tap_get_support"

	/// Started IFPS Lookup
	case _20201121_SIL = "started_IFPS_lookup"

	/// Resolved IPFS Address
	case _20201121_DRIA = "did_resolve_IPFS_address"

	/// Failed to resolve IPFS Address
	case _20201121_FRIA = "failed_resolve_IPFS_address"

	/// User tapped balance
	case _20200207_DTHB = "did_tap_header_balance"

	/// Heartbeat check If event even happens
	case _20210427_HCIEEH = "heartbeat_check_if_event_even_happens"

	/// User Tapped on  UD Image
	case _20220822_UTOU = "user_tapped_on_ud"

	/// User registered Pusher interest
	case _20231202_RIGI = "registered_ios_general_interest"

	/// User accepted pushes
	case _20231225_UAP = "user_accepted_push"

	/// User signup
	case _20240101_US = "user_signup"

	/// Transactions info
	case _20240214_TI = "transactions_info"

	/// Transactions info
	case _20240315_AI = "application_info"
}
