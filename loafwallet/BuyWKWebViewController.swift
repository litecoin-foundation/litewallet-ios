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
    
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var didDismissChildView: (() -> ())? 

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
        setupSubViews()
        loadRequest()
     }

    private func setupSubViews() {
        currentAddressLabel.text = currentWalletAddress
    }
    
    private func loadRequest() {
        guard let url = URL(string: "https://www.yahoo.com") else {
        NSLog("ERROR: URL not initialized")
            return
        }
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }
     
    @IBAction func backAction(_ sender: Any) {
       didDismissChildView?()
    }
    
}
