//
//  TransactionsViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import StoreKit
import QREncoder

private let promptDelay: TimeInterval = 0.6

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Subscriber, Trackable {

    @IBOutlet weak var tableView: UITableView!
    
    let syncingView = SyncingView()
    var store: Store?
    var walletManager: WalletManager?
    var selectedIndexes = [IndexPath: NSNumber]()
    var isSearchActive: Bool = false
    var filteredTransactions: [Transaction] = []
    private var transactions: [Transaction] = []
    private var allTransactions: [Transaction] = [] {
        didSet {
            transactions = allTransactions
        }
    }
    private var rate: Rate? {
        didSet {
            reload()
        }
    }
    
    var isLtcSwapped: Bool? {
        didSet {
            reload()
        }
    }
    var isSyncingViewVisible = false {
        didSet {
            guard oldValue != isSyncingViewVisible else { return } //We only care about changes
            if isSyncingViewVisible {
                tableView.beginUpdates()
                if currentPrompt != nil {
                    currentPrompt = nil
                    tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else {
                    tableView.insertSections(IndexSet(integer: 0), with: .automatic)
                }
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
                tableView.endUpdates()

                DispatchQueue.main.asyncAfter(deadline: .now() + promptDelay , execute: {
                    self.attemptShowPrompt()
                })
            }
        }
    }

    var filters: [TransactionFilter] = [] {
        didSet {
            transactions = filters.reduce(allTransactions, { $0.filter($1) })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let emptyMessage = UILabel.wrapping(font: .customBody(size: 16.0), color: .grayTextTint)
    
    private var currentPrompt: Prompt? {
        didSet {
            if currentPrompt != nil && oldValue == nil {
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(integer: 0), with: .automatic)
                tableView.endUpdates()
            } else if currentPrompt == nil && oldValue != nil && !isSyncingViewVisible {
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    private var hasExtraSection: Bool {
        return isSyncingViewVisible || (currentPrompt != nil)
    }
    
    private func attemptShowPrompt() {
        guard let walletManager = walletManager else { return }
        guard !isSyncingViewVisible else { return }
        
        guard let store = self.store else {
             NSLog("ERROR - Store not passed")
             return
        }
        let types = PromptType.defaultOrder
        if let type = types.first(where: { $0.shouldPrompt(walletManager: walletManager, state: store.state) }) {
            self.saveEvent("prompt.\(type.name).displayed")
            currentPrompt = Prompt(type: type)
            currentPrompt?.close.tap = { [weak self] in
                self?.saveEvent("prompt.\(type.name).dismissed")
                self?.currentPrompt = nil
            }
            if type == .biometrics {
                UserDefaults.hasPromptedBiometrics = true
            }
            if type == .shareData {
                UserDefaults.hasPromptedShareData = true
            }
        } else {
            currentPrompt = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    override func viewDidLoad() {
      setup()
      addSubscriptions()
    }
    
    private func setup() {
        self.transactions = TransactionManager.sharedInstance.transactions
        self.rate = TransactionManager.sharedInstance.rate
     }
    
    private func addSubscriptions() {
        
       guard let store = self.store else {
            NSLog("ERROR - Store not passed")
            return
       }

       store.subscribe(self, selector: { $0.walletState.transactions != $1.walletState.transactions },
                       callback: { state in
                           self.allTransactions = state.walletState.transactions
                           self.reload()
       })

       store.subscribe(self,
                       selector: { $0.isLtcSwapped != $1.isLtcSwapped },
                       callback: { self.isLtcSwapped = $0.isLtcSwapped })
       store.subscribe(self,
                       selector: { $0.currentRate != $1.currentRate},
                       callback: { self.rate = $0.currentRate })
       store.subscribe(self, selector: { $0.maxDigits != $1.maxDigits }, callback: {_ in
           self.reload()
       })

       store.subscribe(self, selector: { $0.walletState.syncState != $1.walletState.syncState
       }, callback: {
           if $0.walletState.syncState == .syncing {
               self.syncingView.reset()
           } else if $0.walletState.syncState == .connecting {
               self.syncingView.setIsConnecting()
           }
       })

       store.subscribe(self, selector: { $0.recommendRescan != $1.recommendRescan }, callback: { _ in
           self.attemptShowPrompt()
       })
       store.subscribe(self, selector: { $0.walletState.syncState != $1.walletState.syncState }, callback: { _ in
           self.reload()
       })
       store.subscribe(self, name: .didUpgradePin, callback: { _ in
           if self.currentPrompt?.type == .upgradePin {
               self.currentPrompt = nil
           }
       })
       store.subscribe(self, name: .didEnableShareData, callback: { _ in
           if self.currentPrompt?.type == .shareData {
               self.currentPrompt = nil
           }
       })
       store.subscribe(self, name: .didWritePaperKey, callback: { _ in
           if self.currentPrompt?.type == .paperKey {
               self.currentPrompt = nil
           }
       })

       store.subscribe(self, name: .txMemoUpdated(""), callback: {
           guard let trigger = $0 else { return }
           if case .txMemoUpdated(let txHash) = trigger {
               self.reload(txHash: txHash)
           }
       })

       emptyMessage.textAlignment = .center
       emptyMessage.text = S.TransactionDetails.emptyMessage
       reload()
    }
    
    
    private func reload() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
 
//            DispatchQueue.main.sync {
//                if self.transactions.count == 0 {
//                    if self.emptyMessage.superview == nil {
//                        self.tableView.addSubview(self.emptyMessage)
//                        self.emptyMessage.constrain([
//                            self.emptyMessage.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
//                            self.emptyMessage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
//                            self.emptyMessage.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -C.padding[2]) ])
//                    }
//                } else {
//                    self.emptyMessage.removeFromSuperview()
//                }
//            }
        }
    }
    
   private func checkTransactionCountForReview(transactions: [Transaction]) {
      
      if  transactions.count % 3 == 0 &&
          transactions.count < 7 {
        
        if #available( iOS 10.3,*){
          SKStoreReviewController.requestReview()
        }
      }
    }
    
    private func reload(txHash: String) {
        self.transactions.enumerated().forEach { i, tx in
            if tx.hash == txHash {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [IndexPath(row: i, section: self.hasExtraSection ? 1 : 0)], with: .automatic)
                    self.tableView.endUpdates()
                    self.checkTransactionCountForReview(transactions: self.transactions)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        if transactions.count > 0 {
            return transactions.count
        } else {
            self.tableView.backgroundView = emptyMessageView()
            self.tableView.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        if cellIsSelected(indexPath: indexPath) {
            return kMaxTransactionCellHeight
        } else {
            return kMaxTransactionCellHeight / 3.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        var transaction: Transaction?
        if isSearchActive {
            transaction = filteredTransactions[indexPath.row]
        } else {
            transaction = transactions[indexPath.row]
        }
         
        return configureTransactionCell(transaction:transaction, indexPath: indexPath)
    }
    
    private func configureTransactionCell(transaction:Transaction?, indexPath: IndexPath) -> TransactionTableViewCellv2 {
         
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVC2", for: indexPath) as? TransactionTableViewCellv2 else {
            NSLog("ERROR No cell found")
            return TransactionTableViewCellv2()
        }
          
        if let transaction = transaction,
            let isLTCSwapped = self.isLtcSwapped {
       
        cell.setupViews()
        cell.addressLabel.text = transaction.toAddress
                cell.timedateLabel.text = transaction.shortTimestamp
                
                cell.isExpanded = cellIsSelected(indexPath: indexPath)
                cell.expandCardView.alpha = 0.0
                
                var imageName = ""
                var imageTint = UIColor.white
                switch transaction.direction {
                case .received:
                    imageName = "down-chevron-green"
                    imageTint = .litecoinGreen
                case .sent:
                    imageName = "up-chevron-gray"
                    imageTint = .litecoinOrange
                case .moved:
                    imageName = "movedTransaction"
                    imageTint = .litecoinGray
                }
             
                cell.arrowImageView.image = UIImage(named: imageName)
                cell.arrowImageView.tintColor = imageTint
                cell.amountLabel.text = transaction.amountDetails(isLtcSwapped: isLTCSwapped, rate: self.rate!, rates: [self.rate!], maxDigits: 6)
            
                cell.statusLabel.text = transaction.status
                
                cell.moreOrLessLabel.text = cellIsSelected(indexPath: indexPath) ? S.TransactionDetails.less.uppercased() : S.TransactionDetails.more.uppercased()
                
                cell.staticTxIDLabel.text = S.TransactionDetails.staticTXIDLabel
                cell.txidStringLabel.text = transaction.hash
                
                cell.staticAmountDetailLabel.text = S.Confirmation.amountDetailLabel.uppercased() + ":"
                
                cell.startingBalanceLabel.text =  transaction.amountDetailsStartingBalanceString(isLtcSwapped: false, rate: self.rate!, rates: [self.rate!], maxDigits: 6)
                cell.endingBalanceLabel.text = transaction.amountDetailsEndingBalanceString(isLtcSwapped: isLTCSwapped, rate: self.rate!, rates: [self.rate!], maxDigits: 6)
                 
                cell.staticBlockLabel.text = S.TransactionDetails.blockHeightLabel.uppercased() + ":"
                cell.blockLabel.text = transaction.blockHeight
                
                cell.addressLabel.text = transaction.toAddress
                
                cell.staticCommentLabel.text = S.TransactionDetails.commentsHeader.uppercased() + ":"
                if transaction.comment != "" {
                    cell.memoTextLabel.text = transaction.comment
                } else {
                    cell.memoTextLabel.text = "--"
                }
                ///<div>Icons made by <a href="https://www.flaticon.com/authors/becris" title="Becris">Becris</a> from <a href="https://www.flaticon.com/"             title="Flaticon">www.flaticon.com</a></div>
                
                cell.showQRModalAction = { [unowned self] in
                    
                    if let addressString = transaction.toAddress,
                        let qrImage = transaction.toAddress?.qrCode,
                        let receiveLTCtoAddressModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFModalReceiveQRViewController") as? LFModalReceiveQRViewController {
                        
                        receiveLTCtoAddressModal.providesPresentationContextTransitionStyle = true
                        receiveLTCtoAddressModal.definesPresentationContext = true
                        receiveLTCtoAddressModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        receiveLTCtoAddressModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        receiveLTCtoAddressModal.dismissQRModalAction = { [unowned self] in
                          self.dismiss(animated: true, completion: nil)
                        }
                        
                        self.present(receiveLTCtoAddressModal, animated: true) {
                             receiveLTCtoAddressModal.addressLabel.text = addressString
                             receiveLTCtoAddressModal.qrImageView.image = qrImage
                             receiveLTCtoAddressModal.receiveModalTitleLabel.text = S.TransactionDetails.receiveModaltitle
                        }
                    }
                }
        } else {
            assertionFailure("ERROR must have transaction")
        }
        return cell
    }
      
    private func cellIsSelected(indexPath: IndexPath) -> Bool {
        
        let cellIsSelected = selectedIndexes[indexPath] as? Bool ?? false
        return  cellIsSelected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let isSelected = !self.cellIsSelected(indexPath: indexPath)
        let selectedIndex = NSNumber(value: isSelected)
 
        if let selectedCell = tableView.cellForRow(at: indexPath) as? TransactionTableViewCellv2 {
            
            selectedCell.moreOrLessLabel.text = isSelected ? S.TransactionDetails.less.uppercased() : S.TransactionDetails.more.uppercased()
            
            if isSelected {
                let expandCardHeight = 195.0
                let newAlpha = 1.0
                UIView.animate(withDuration: 0.9, animations: {
                    selectedCell.expandCardHeightLayoutContstraint.constant = CGFloat(expandCardHeight)
                    selectedCell.expandCardView.alpha = CGFloat(newAlpha)
                })
            } else {
                let expandCardHeight = 0.0
                let newAlpha = 0.0
                UIView.animate(withDuration: 0.2, animations: {
                    selectedCell.expandCardHeightLayoutContstraint.constant = CGFloat(expandCardHeight)
                    selectedCell.expandCardView.alpha = CGFloat(newAlpha)
                })
            }
        }
        
        selectedIndexes[indexPath] = selectedIndex
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func emptyMessageView() -> UILabel {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = S.TransactionDetails.emptyMessage
        messageLabel.textColor = .litecoinGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.barloweMedium(size: 20)
        messageLabel.sizeToFit()
        self.tableView.backgroundView = messageLabel
        self.tableView.separatorStyle = .none
        return messageLabel
    }
}
