//
//  BuyWKWebViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/18/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import WebKit

class BuyWKWebViewController: UIViewController {
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var wkWebView: WKWebView!
    
    private let uuidString : String = {
        return  UIDevice.current.identifierForVendor?.uuidString ?? ""
    }()
    private let currentWalletAddress : String = {
        return WalletManager.sharedInstance.wallet?.receiveAddress ?? ""
    }()
    private let currencyCode : String = {
        let localeCode = Locale.current.currencyCode ?? "USD"
        return Currency.returnSimplexSupportedFiat(givenCode: localeCode)
    }()
    
    var partnerPrefixString : String?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
     }

}
