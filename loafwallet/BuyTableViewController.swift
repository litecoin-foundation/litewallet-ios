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
        
        if let vcWKVC = UIStoryboard.init(name: "Buy", bundle: nil).instantiateViewController(withIdentifier: "BuyWKWebViewController") as? BuyWKWebViewController {
            //mountPoint + "_simplex"
            addChildViewController(vcWKVC)
            self.view.addSubview(vcWKVC.view)
            vcWKVC.didMove(toParentViewController: self)
        } else {
            print("XXXXX cannot init vc")
        }
    }
    
    var store: Store?
    var walletManager: WalletManager?
    let mountPoint = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thinHeaderView = UIView()
        thinHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        thinHeaderView.backgroundColor = .white
        tableView.tableHeaderView = thinHeaderView
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
}
