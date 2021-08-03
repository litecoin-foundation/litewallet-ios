//
//  TransferAmountViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/17/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import KeychainAccess
import UIKit
import BRCore

class TransferAmountViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    @Published
    var walletType: WalletType
       
    //MARK: - Private Variables
    private let keychain = Keychain(service: "com.litecoincard.service")
    
    private let walletManager: WalletManager
    
    private let store: Store
    
    private var sender: Sender?
    
    //MARK: - Public Variables
    var litewalletBalance: Double =  0.0
    
    var litewalletAddress: String = ""
    
    var cardBalance: Double = 0.0
    
    var cardAddress: String = ""
    
    var currentBalance: Double = 0.0
    
    var transferAmount: Double = 0.0
    
    /// This is the LTC address the wallet is sending LTC TO
    var destinationAddress: String {
        return walletType == .litewallet ? cardAddress : litewalletAddress
    }
    
    var transaction: BRTxRef?
     
    init(walletType: WalletType,
         litewalletBalance: Double,
         litewalletAddress: String,
         cardBalance: Double,
         cardAddress: String,
         walletManager: WalletManager,
         store: Store) {
        
        self.walletManager = walletManager
        
        self.store = store
        
        self.walletType = walletType 
        
        self.litewalletBalance = litewalletBalance
        
        self.litewalletAddress = litewalletAddress
        
        self.cardBalance = cardBalance
        
        self.cardAddress = cardAddress
        
        currentBalance = walletType == .litewallet ? litewalletBalance : cardBalance
        
    }
    
    /// Transfer Litecoin from **Litecoin Card to Litewallet**
    /// - Parameters:
    ///   - amount: Litecoin to 6 decimal places
    ///   - completion: To complete process
    ///   - address: Destination Litecoin address
    func transferToLitewallet(amount: Double,
                              address: String,
                              completion: @escaping () -> Void) {
        print("XX Transfer to Litewallet:\n")
        print("XX Address: \(address)")
        print("XX Amount: \(amount) Ł")
        
        guard let token = keychain["token"] ,
              let userID = keychain["userID"] else {
            return
        }
        
        PartnerAPI
            .shared
            .withdrawToWallet(userID: userID,
                              withdrawal:
                                ["amount": amount,
                                 "wallet_address": address]) { dict in
                
                //
            }
        
    }
    
    /// Transfer Litecoin from **Litewallet to Litecoin Card**
    /// - Parameters:
    ///   - amount: Litecoin to 6 decimal places
    ///   - completion: To complete process
    ///   - address: Destination Litecoin address
    func transferToCard(amount: Double,
                        address: String,
                        completion: @escaping (Bool) -> Void) {
         
        /// 1 Litecoin = 100 000 000 litoshis
        /// Litewallet core calculates values in litoshis
        let litoshis = UInt64(amount * 100_000_000)
        
        //////////// MOCK VALUE /////// : MTiCxZ2MWWZqaCPMPXk9RcKkncXtaf1d6o
        let payKerry = "MTiCxZ2MWWZqaCPMPXk9RcKkncXtaf1d6o"
        transaction = walletManager.wallet?.createTransaction(forAmount: litoshis, toAddress: payKerry)
        
        guard let kvStore = walletManager.apiClient?.kv else { return }

        self.sender = Sender(walletManager: self.walletManager, kvStore: kvStore, store: self.store)
        
        sender?.sendToCard(amount: litoshis,
                           toAddress: payKerry) { didSend in
                 completion(didSend)
        }

    }
    
}


