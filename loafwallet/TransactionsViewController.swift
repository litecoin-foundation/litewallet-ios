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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var store: Store? = nil
    var transactions: [Transaction]?
    var walletManager: WalletManager?
    var selectedIndexes = [IndexPath: NSNumber]()
    var isSearchActive: Bool = false
    var filteredTransactions: [Transaction] = []
    
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
         
        //Customize Search Bar
        self.searchBar.backgroundColor = .liteWalletBlue
        self.searchBar.barTintColor = .liteWalletBlue
        self.searchBar.tintColor = .white
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.searchTextField.backgroundColor = .white
        self.searchBar.searchTextField.tintColor = .black
        self.searchBar.searchTextField.font = .barloweRegular(size: 14)
        self.searchBar.backgroundImage = UIImage()
     }
    
    
    private func addSubscriptions() {
        
        guard let store = self.store else {
            NSLog("ERROR - Store not passed")
            return
        }

        store.subscribe(self, selector: { $0.walletState.transactions != $1.walletState.transactions },
                        callback: { state in
                            self.transactions = state.walletState.transactions
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
                //self.syncingView.reset()
            } else if $0.walletState.syncState == .connecting {
                //self.syncingView.setIsConnecting()
            }
        })

        store.subscribe(self, selector: { $0.recommendRescan != $1.recommendRescan }, callback: { _ in
            //self.attemptShowPrompt()
        })
        store.subscribe(self, selector: { $0.walletState.syncState != $1.walletState.syncState }, callback: { _ in
            self.reload()
        })
        store.subscribe(self, name: .didUpgradePin, callback: { _ in
//            if self.currentPrompt?.type == .upgradePin {
//                self.currentPrompt = nil
//            }
        })
         
        store.subscribe(self, name: .didEnableShareData, callback: { _ in
//            if self.currentPrompt?.type == .shareData {
//                self.currentPrompt = nil
//            }
        })
        store.subscribe(self, name: .didWritePaperKey, callback: { _ in
//            if self.currentPrompt?.type == .paperKey {
//                self.currentPrompt = nil
//            }
        })

        store.subscribe(self, name: .txMemoUpdated(""), callback: {
            guard let trigger = $0 else { return }
            if case .txMemoUpdated(let txHash) = trigger {
                self.reload(txHash: txHash)
            }
        })
    }
    private func reload() {
        //tableView.reloadData()
        
        if self.transactions?.count == 0 {
            ///Add Empty Message behind table View
        } else {
        ///remove empty Message
        }
    }
    
    private func reload(txHash: String) {
        self.transactions?.enumerated().forEach { i, tx in
            if tx.hash == txHash {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    //TODO: find out what this does
                    //self.tableView.reloadRows(at: [IndexPath(row: i, section: self.hasExtraSection ? 1 : 0)], with: .automatic)
                    self.tableView.endUpdates()
                    // Cehck how many transactions before asking for reating in the App Store
                    //self.checkTransactionCountForReview(transactions: self.transactions)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let transactionsCount = transactions?.count else { return 0 }
        if transactionsCount > 0 {
            return transactionsCount
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
            transaction = transactions?[indexPath.row]
        }
         
        return configureTransactionCell(transaction:transaction, indexPath: indexPath)
    }
    
    private func configureTransactionCell(transaction:Transaction?, indexPath: IndexPath) -> TransactionTableViewCellv2 {
         
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVC", for: indexPath) as? TransactionTableViewCellv2 else {
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
                cell.exchangeRateLabel.text = transaction.amountExchangeString(isLtcSwapped: isLTCSwapped, rate: self.rate!, rates: [self.rate!], maxDigits: 6)
                
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

extension TransactionsViewController:  UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let transactions = self.transactions else {
            NSLog("Error: Transactions is nil")
            return
        }
        
        filteredTransactions = transactions.filter({  $0.longTimestamp.contains(searchText) })
        
        //|| $0.toAddress?.contains(searchText) || $0.comment?.contains(searchText)
        if filteredTransactions.count == 0 {
            isSearchActive = false
        } else {
            isSearchActive = true
        }
        tableView.reloadData()
    }
}
 
 
//    let didSelectTransaction: ([Transaction], Int) -> Void
//    let syncingView = SyncingView()
//
//    var isSyncingViewVisible = false {
//        didSet {
//            guard oldValue != isSyncingViewVisible else { return } //We only care about changes
//            if isSyncingViewVisible {
//                tableView.beginUpdates()
//                if currentPrompt != nil {
//                    currentPrompt = nil
//                    tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                } else {
//                    tableView.insertSections(IndexSet(integer: 0), with: .automatic)
//                }
//                tableView.endUpdates()
//            } else {
//                tableView.beginUpdates()
//                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
//                tableView.endUpdates()
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + promptDelay , execute: {
//                    self.attemptShowPrompt()
//                })
//            }
//        }
//    }
//
//



//    private let emptyMessage = UILabel.wrapping(font: .customBody(size: 16.0), color: .grayTextTint)
//    private var currentPrompt: Prompt? {
//        didSet {
//            if currentPrompt != nil && oldValue == nil {
//                tableView.beginUpdates()
//                tableView.insertSections(IndexSet(integer: 0), with: .automatic)
//                tableView.endUpdates()
//            } else if currentPrompt == nil && oldValue != nil && !isSyncingViewVisible {
//                tableView.beginUpdates()
//                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
//                tableView.endUpdates()
//            }
//        }
//    }
//    private var hasExtraSection: Bool {
//        return isSyncingViewVisible || (currentPrompt != nil)
//    }
//
//    }
//
//    func setup() {
//
//
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DispatchQueue.main.asyncAfter(deadline: .now() + promptDelay, execute: { [weak self] in
//            guard let myself = self else { return }
//            if !myself.isSyncingViewVisible {
//                myself.attemptShowPrompt()
//            }
//        })
//    }
 

//
//    // MARK: - Table view data source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return hasExtraSection ? 2 : 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if hasExtraSection && section == 0 {
//            return 1
//        } else {
//            return transactions.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let store = self.returnStoreObject()
//
//        if hasExtraSection && indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier, for: indexPath)
//            if let transactionCell = cell as? TransactionTableViewCell {
//                transactionCell.setStyle(.single)
//                transactionCell.container.subviews.forEach {
//                    $0.removeFromSuperview()
//                }
//                if let prompt = currentPrompt {
//                    transactionCell.container.addSubview(prompt)
//                    prompt.constrain(toSuperviewEdges: nil)
//                    prompt.constrain([
//                        prompt.heightAnchor.constraint(equalToConstant: 88.0) ])
//                    transactionCell.selectionStyle = .default
//                } else {
//                    transactionCell.container.addSubview(syncingView)
//                    syncingView.constrain(toSuperviewEdges: nil)
//                    syncingView.constrain([
//                        syncingView.heightAnchor.constraint(equalToConstant: 88.0) ])
//                    transactionCell.selectionStyle = .none
//                }
//            }
//            return cell
//        } else {
//            let numRows = tableView.numberOfRows(inSection: indexPath.section)
//            var style: TransactionCellStyle = .middle
//            if numRows == 1 {
//                style = .single
//            }
//            if numRows > 1 {
//                if indexPath.row == 0 {
//                    style = .first
//                }
//                if indexPath.row == numRows - 1 {
//                    style = .last
//                }
//            }
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellIdentifier, for: indexPath)
//            if let transactionCell = cell as? TransactionTableViewCell, let rate = rate, let maxDigits = store?.state.maxDigits {
//                transactionCell.setStyle(style)
//                transactionCell.setTransaction(transactions[indexPath.row], isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: maxDigits, isSyncing: store?.state.walletState.syncState != .success)
//            }
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if hasExtraSection && section == 1 {
//            return C.padding[2]
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if hasExtraSection && section == 1 {
//            return UIView(color: .clear)
//        } else {
//            return nil
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if isSyncingViewVisible && indexPath.section == 0 { return }
//
//        let store = returnStoreObject()
//        if let currentPrompt = currentPrompt, indexPath.section == 0 {
//            if let trigger = currentPrompt.type.trigger {
//                store?.trigger(name: trigger)
//            }
//            saveEvent("prompt.\(currentPrompt.type.name).trigger")
//            self.currentPrompt = nil
//            return
//        }
//        didSelectTransaction(transactions, indexPath.row)
//    }
//

//
//    private func attemptShowPrompt() {
//        guard let walletManager = walletManager else { return }
//        guard !isSyncingViewVisible else { return }
//        let types = PromptType.defaultOrder
//        if let state = store?.state, let type = types.first(where: { $0.shouldPrompt(walletManager: walletManager, state: state) }) {
//            self.saveEvent("prompt.\(type.name).displayed")
//            currentPrompt = Prompt(type: type)
//            currentPrompt?.close.tap = { [weak self] in
//                self?.saveEvent("prompt.\(type.name).dismissed")
//                self?.currentPrompt = nil
//            }
//            if type == .biometrics {
//                UserDefaults.hasPromptedBiometrics = true
//            }
//            if type == .shareData {
//                UserDefaults.hasPromptedShareData = true
//            }
//        } else {
//            currentPrompt = nil
//        }
//    }
//
////    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//
//    private func returnStoreObject() -> Store? {
//        guard let store = self.store else {
//            NSLog("ERROR: Store not initialized")
//            return nil
//        }
//        return store
//    }



