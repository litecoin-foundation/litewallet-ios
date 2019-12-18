//
//  BuyTableViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/18/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit

class BuyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

//
//    func didClickPartnerCell(partner: String) {
//
//
//        guard let store = self.store else {
//            NSLog("ERROR: Store not initialized")
//            return
//        }
//
//        guard let walletManager = self.walletManager else {
//            NSLog("ERROR Wallet manager not initialized")
//            return
//        }
//
//
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
//    }
//
//    @objc func dismissWebContainer() {
//        dismiss(animated: true, completion: nil)
//    }
}
