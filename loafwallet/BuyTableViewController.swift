//
//  BuyTableViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/18/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
import SwiftUI

class BuyTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var bitrefillLogoImageView: UIImageView!
    @IBOutlet weak var bitrefillHeaderLabel: UILabel!
    @IBOutlet weak var bitrefillDetailsLabel: UILabel!
    @IBOutlet weak var bitrefillCellContainerView: UIView!

    @IBAction func didTapBitrefill(_ sender: UIButton) {
 
       guard let url = URL(string: "https://www.bitrefill.com/?ref=DkvP2hyt") else
        {
           return
       }
 
        let sfSafariVC = SFSafariViewController(url: url)
        sfSafariVC.delegate = self
        present(sfSafariVC, animated: true)
    }
    
    //MARK: Moonpay UI
    @IBOutlet weak var moonpayLogoImageView: UIImageView!
    @IBOutlet weak var moonpayHeaderLabel: UILabel!
    @IBOutlet weak var moonpayDetailsLabel: UILabel!
    @IBOutlet weak var moonpayCellContainerView: UIView!
    @IBOutlet weak var moonpaySegmentedControl: UISegmentedControl!
    
    @IBAction func didTapMoonpay(_ sender: Any) {
        
        let timestamp = Int(appInstallDate.timeIntervalSince1970)
        
        let urlString = APIServer.baseUrl + "moonpay/buy" + "?address=\(currentWalletAddress)&idate=\(timestamp)&uid=\(uuidString)&code=\(currencyCode)"
        
        guard let url = URL(string: urlString) else { return }
        
        let sfSafariVC = SFSafariViewController(url: url)
        sfSafariVC.delegate = self
        present(sfSafariVC, animated: true)
    }
    
    //MARK: Simplex UI
    @IBOutlet weak var simplexLogoImageView: UIImageView!
    @IBOutlet weak var simplexHeaderLabel: UILabel!
    @IBOutlet weak var simplexDetailsLabel: UILabel!
    @IBOutlet weak var simplexCellContainerView: UIView!
    @IBOutlet weak var simplexCurrencySegmentedControl: UISegmentedControl!
    
    private var currencyCode: String = "USD"
    
    @IBAction func didTapSimplex(_ sender: Any) {
        
        if let vcWKVC = UIStoryboard.init(name: "Buy", bundle: nil).instantiateViewController(withIdentifier: "BuyWKWebViewController") as? BuyWKWebViewController { 
            vcWKVC.currencyCode = currencyCode
            vcWKVC.currentWalletAddress = currentWalletAddress
            vcWKVC.uuidString = uuidString
            vcWKVC.timestamp = Int(appInstallDate.timeIntervalSince1970)
            
            addChildViewController(vcWKVC)
            self.view.addSubview(vcWKVC.view)
            vcWKVC.didMove(toParentViewController: self)
           
            vcWKVC.didDismissChildView = {
                for vc in self.childViewControllers {
                    DispatchQueue.main.async {
                        vc.willMove(toParentViewController: nil)
                        vc.view.removeFromSuperview()
                        vc.removeFromParentViewController()
                    }
                }
            }
            
        }  else {
            NSLog("ERROR: Storyboard not initialized")
        }
    }
    
    var store: Store?
    var walletManager: WalletManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thinHeaderView = UIView()
        thinHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.0)
        thinHeaderView.backgroundColor = .white
        tableView.tableHeaderView = thinHeaderView
        tableView.tableFooterView = UIView()
        
        moonpaySegmentedControl.addTarget(self, action: #selector(didChangeCurrencyMoonpay), for: .valueChanged)
        moonpaySegmentedControl.selectedSegmentIndex = PartnerFiatOptions.usd.index
        moonpaySegmentedControl.selectedSegmentTintColor = .white
        moonpaySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        moonpaySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.liteWalletBlue], for: .selected)
        
        simplexCurrencySegmentedControl.addTarget(self, action: #selector(didChangeCurrencySimplex), for: .valueChanged)
        simplexCurrencySegmentedControl.selectedSegmentIndex = PartnerFiatOptions.usd.index
        simplexCurrencySegmentedControl.selectedSegmentTintColor = .white
        simplexCurrencySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        simplexCurrencySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.liteWalletBlue], for: .selected)
        
        setupWkVCData()
    }
    
    private func setupWkVCData() {
        
        let moonpayData = Partner.partnerDataArray()[0]
        moonpayLogoImageView.image = moonpayData.logo
        moonpayHeaderLabel.text = moonpayData.headerTitle
        moonpayDetailsLabel.text = moonpayData.details
        moonpayCellContainerView.layer.cornerRadius = 6.0
        moonpayCellContainerView.layer.borderColor = UIColor.white.cgColor
        moonpayCellContainerView.layer.borderWidth = 1.0
        moonpayCellContainerView.clipsToBounds = true
        
        let simplexData = Partner.partnerDataArray()[1]
        simplexLogoImageView.image = simplexData.logo
        simplexHeaderLabel.text = simplexData.headerTitle
        simplexDetailsLabel.text = simplexData.details
        simplexCellContainerView.layer.cornerRadius = 6.0
        simplexCellContainerView.layer.borderColor = UIColor.white.cgColor
        simplexCellContainerView.layer.borderWidth = 1.0
        simplexCellContainerView.clipsToBounds = true
    }
    
    
    private let uuidString : String = {
        return  UIDevice.current.identifierForVendor?.uuidString ?? ""
    }()
    
    private let currentWalletAddress : String = {
        return WalletManager.sharedInstance.wallet?.receiveAddress ?? ""
    }()
    
    private let appInstallDate : Date = {
        if let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            if let installDate = try! FileManager.default.attributesOfItem(atPath: documentsFolder.path)[.creationDate] as? Date {
                return installDate
            }
        }
        return Date()
    }()
    
    @objc private func didChangeCurrencyMoonpay() {
        if let code = PartnerFiatOptions(rawValue: moonpaySegmentedControl.selectedSegmentIndex)?.description {
            self.currencyCode = code
        } else {
            print("Error: Code not found: \(moonpaySegmentedControl.selectedSegmentIndex)")
        }
    }
    
    @objc private func didChangeCurrencySimplex() {
        if let code = PartnerFiatOptions(rawValue: simplexCurrencySegmentedControl.selectedSegmentIndex)?.description {
            self.currencyCode = code
        } else {
            print("Error: Code not found: \(simplexCurrencySegmentedControl.selectedSegmentIndex)")
        }
    }
}

