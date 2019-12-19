//
//  BuyTableViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/18/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit

class BuyTableViewController: UITableViewController {
 
    
    @IBOutlet weak var simplexLogoImageView: UIImageView!
    @IBOutlet weak var simplexHeaderLabel: UILabel!
    @IBOutlet weak var simplexDetailsLabel: UILabel!
    @IBOutlet weak var simplexCellContainerView: UIView!
    
    @IBAction func didTapSimplex(_ sender: Any) {
        didClickPartnerCell(partner: "Simplex")
    }
    
    var store: Store?
    var walletManager: WalletManager?
    let mountPoint = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupData()
    }

 
    private func setupData() {
        
        let simplexData = Partner.partnerDataArray()[0]
        simplexLogoImageView.image = simplexData.logo
        simplexHeaderLabel.text = simplexData.headerTitle
        simplexDetailsLabel.text = simplexData.details
        simplexCellContainerView.layer.cornerRadius = 5.0
        simplexCellContainerView.layer.borderColor = UIColor.white.cgColor
        simplexCellContainerView.layer.borderWidth = 2.0
        simplexCellContainerView.clipsToBounds = true
    }
 
    @objc func didClickPartnerCell(partner: String) {

        guard let store = self.store else {
            NSLog("ERROR: Store not initialized")
            return
        }

//        switch partner {
//        case "Simplex":
//            let simplexWebviewVC = BRWebViewController(partner: "Simplex", mountPoint: mountPoint + "_simplex", walletManager: walletManager, store: store, noAuthApiClient: nil)
//            present(simplexWebviewVC, animated: true
//                , completion: nil)
//        case "Changelly":
//            print("Changelly No Code Placeholder")
//        case "Coinbase":
//            let coinbaseWebViewWC = BRWebViewController(partner: "Coinbase", mountPoint: mountPoint + "_coinbase", walletManager: walletManager, store: store, noAuthApiClient: nil)
//            present(coinbaseWebViewWC, animated: true) {
//                //
//            }
//        default:
//            fatalError("No Partner Chosen")
//        }
    }

    @objc func dismissWebContainer() {
        dismiss(animated: true, completion: nil)
    }
}
