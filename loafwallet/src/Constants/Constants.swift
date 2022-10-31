//
//  Constants.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-24.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

let π: CGFloat = .pi

/// Sets tthe wallet type, the image and the label
enum WalletType: String {
    
    case litecoinCard
    case litewallet
    
    var description: String {
        switch self {
            case .litecoinCard:
                return "litecoin-front-card-border"
            case .litewallet:
                return "coinBlueWhite"
        }
    }
    
    var balanceLabel: String {
        switch self {
            case .litecoinCard:
                return S.LitecoinCard.cardBalance
            case .litewallet:
                return S.LitecoinCard.Transfer.litewalletBalance
        }
    }
    
    var nameLabel: String {
        switch self {
            case .litecoinCard:
                return S.LitecoinCard.name
            case .litewallet:
                return S.Litewallet.name
        }
    }
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
    
    /// Ternio API Wallet details failure
    case _20210405_TAWDF = "ternio_api_wallet_details_failure"
    
    /// Ternio API Authenticate Enable 2FA change
    case _20210804_TAA2FAC = "ternio_API_auth_2FA_change"
    
    /// Ternio API Wallet details success
    case _20210804_TAWDS = "ternio_API_wallet_details_success"
    
    /// Ternio API Login
    case _20210804_TAULI = "ternio_API_user_log_in"
    
    /// Ternio API Logout
    case _20210804_TAULO = "ternio_API_user_log_out"
    
    /// Heartbeat check If event even happens
    case _20210427_HCIEEH = "heartbeat_check_if_event_even_happens"
    
    /// User Tapped on  UD Image
    case _20220822_UTOU = "user_tapped_on_ud"
    
}

struct FoundationSupport {

    static let dashboard = "https://litecoinfoundation.zendesk.com/"

    /// Litecoin Foundation main donation address: MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe
    /// As of Nov 14th, 2020
    static let donationLTCAddress = "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe"
} 

struct APIServer {
     
    #if DEBUG
    static let baseUrl = "https://api-stage.lite-wallet.org/"
    #else
    static let baseUrl = "https://api-prod.lite-wallet.org/"
    #endif
} 

struct Padding {
    subscript(multiplier: Int) -> CGFloat {
        get {
            return CGFloat(multiplier) * 8.0
        }
    }
    
    subscript(multiplier: Double) -> CGFloat {
        get {
            return CGFloat(multiplier) * 8.0
        }
    }
}

struct DeviceType {
    
    enum Name  {
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
        static let logoAspectRatio: CGFloat = 125.0/417.0
    }
    static var defaultTintColor: UIColor = {
        return UIView().tintColor
    }()
    static let animationDuration: TimeInterval = 0.3
    static let secondsInDay: TimeInterval = 86400
    static let maxMoney: UInt64 = 84000000*100000000
    static let satoshis: UInt64 = 100000000
    static let walletQueue = "com.litecoin.walletqueue"
    static let btcCurrencyCode = "LTC"
    static let null = "(null)"
    static let maxMemoLength = 250
    static let feedbackEmail = "feedback@litecoinfoundation.zendesk.com"
    static let supportEmail = "support@litecoinfoundation.zendesk.com"
    
    
    static let reviewLink = "https://itunes.apple.com/app/loafwallet-litecoin-wallet/id1119332592?action=write-review"
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
    static let string = "v." + versionNumber! + " (\(buildNumber!))"
}

