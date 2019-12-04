//
//  BuyLTCViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit

let buyCellReuseIdentifier = "buyCell"
let kSectionHeaderHeight: CGFloat = 40.0
class BuyLTCViewController: UIViewController, BuyCenterTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var store: Store?
    var walletManager: WalletManager?
    private let mountPoint: String = ""
    let partnerArray = Partner.dataArray()
     
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupSubViews()
     }
    
    private func setupData() {
        //self.store = store
        //self.walletManager = walletManager
        //self.mountPoint = mountPoint
    }
    
    private func setupSubViews() {
     
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let sectionWidth = CGFloat(self.view.frame.width)
        sectionView.frame = CGRect(x: 0, y: 0, width: sectionWidth, height: kSectionHeaderHeight)
            
        sectionView.backgroundColor = .white
        let headerLabel = UILabel(font: UIFont.barloweBold(size: 18), color: .white)
        headerLabel.backgroundColor = .white
        headerLabel.textColor = .liteWalletBlue
        headerLabel.frame = CGRect(x: 20, y: 0, width: 190, height: kSectionHeaderHeight)
        sectionView.addSubview(headerLabel)
        switch section {
        case 0:
            headerLabel.text = S.BuyCenter.title
        default:
            NSLog("ERROR this VC shouldonly send one header")
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(kSectionHeaderHeight)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partnerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: buyCellReuseIdentifier, for: indexPath) as! BuyCenterTableViewCell
        let partnerData = partnerArray[indexPath.row]
        cell.partnerLabel.text = partnerData["title"] as? String
        cell.financialDetailsLabel.text = (partnerData["details"] as? String)!  /* TODO removed Currency.simplexRanges()*/
        cell.parnerLogoImageView.image = partnerData["logo"] as? UIImage
        cell.frameView.backgroundColor = (partnerData["baseColor"] as? UIColor)!

        cell.containerView.layer.cornerRadius = 5.0
        cell.containerView.clipsToBounds = true
        cell.containerView.layer.borderColor = UIColor.white.cgColor
        cell.containerView.layer.borderWidth = 2.0

        cell.delegate = self
        
        return cell
    }
    
    func didClickPartnerCell(partner: String) {
        
        
        guard let store = self.store else {
            NSLog("ERROR: Store not initialized")
            return
        }
        
        guard let walletManager = self.walletManager else {
            NSLog("ERROR Wallet manager not initialized")
            return
        }
        
        
        switch partner {
        case "Simplex":
            let simplexWebviewVC = BRWebViewController(partner: "Simplex", mountPoint: mountPoint + "_simplex", walletManager: walletManager, store: store, noAuthApiClient: nil)
            present(simplexWebviewVC, animated: true
                , completion: nil)
        case "Changelly":
            print("Changelly No Code Placeholder")
        case "Coinbase":
            let coinbaseWebViewWC = BRWebViewController(partner: "Coinbase", mountPoint: mountPoint + "_coinbase", walletManager: walletManager, store: store, noAuthApiClient: nil)
            present(coinbaseWebViewWC, animated: true) {
                //
            }
        default:
            fatalError("No Partner Chosen")
        }
    }
    
    @objc func dismissWebContainer() {
        dismiss(animated: true, completion: nil)
    }
    
}

protocol BuyCenterTableViewCellDelegate : class {
  func didClickPartnerCell(partner: String)
}

class BuyCenterTableViewCell : UITableViewCell {
    
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var parnerLogoImageView: UIImageView!
  @IBOutlet weak var partnerLabel: UILabel!
  @IBOutlet weak var financialDetailsLabel: UILabel!

   
  private let cellButton = UIButton()
 
  var frameView = UIView()
  weak var delegate : BuyCenterTableViewCellDelegate?
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.backgroundColor = UIColor.clear
    configureViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
   
  func configureViews() {
    cellButton.setTitle(" ", for: .normal)
    cellButton.addTarget(self, action: #selector(cellButtonPressed), for: .touchUpInside)
    cellButton.addTarget(self, action: #selector(cellButtonImageChanged), for: .touchDown)
    cellButton.addTarget(self, action: #selector(cellButtonImageChanged), for: .touchUpOutside)
    
    if #available(iOS 11.0, *),
         let  backgroundColor = UIColor(named: "mainColor") {
         containerView.backgroundColor = backgroundColor
    } else {
         containerView.backgroundColor = .liteWalletBlue
    }
    
  }
   
  
  @objc func cellButtonPressed(selector: UIButton) {
    //selectImage.image = #imageLiteral(resourceName: "whiteRightArrow")
    if let partnerName = partnerLabel.text {
      delegate?.didClickPartnerCell(partner: partnerName)
    }
  }
  
  @objc func cellButtonImageChanged(selector: UIButton) {
   // selectImage.image = #imageLiteral(resourceName: "simplexRightArrow")
  }
  
  
  
}


