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
        
        //DEV: The Testnet is not implemented in Loafwallet Core.
        // This would be used for the Card testing.
        #if DEBUG
        self.litewalletAddress = MockData.testLTCAddress
        #endif
        
        self.cardBalance = cardBalance
        
        self.cardAddress = cardAddress
        
        currentBalance = walletType == .litewallet ? litewalletBalance : cardBalance
        
    }
    
    
    //DEV: Need to get information back from Ternio 2FA
    /// Transfer Litecoin from **Litecoin Card to Litewallet**
    /// - Parameters:
    ///   - amount: Litecoin to 6 decimal places
    ///   - completion: To complete process
    ///   - address: Destination Litecoin address
    func transferToLitewallet(amount: Double,
                              address: String,
                              completion: @escaping () -> Void) {
        
        let keychain = Keychain(service: "com.litecoincard.service")
         
        // Fetches the latest token and UserID
        guard let token = keychain["token"] ,
              let userID = keychain["userID"] else {
            LWAnalytics.logEventWithParameters(itemName:._20210804_ERR_KLF)
            return
        }
        
        PartnerAPI
            .shared
            .withdrawToWallet(userID: userID,
                              token: token,
                              withdrawal:
                                ["amount": amount,
                                 "wallet_address": address]) { dict in
                
                //DEV: Mothballed
                // Need information from Ternio to move forward
                 
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
        
        transaction = walletManager.wallet?.createTransaction(forAmount: litoshis,
                                                              toAddress: address)
        
        guard let kvStore = walletManager.apiClient?.kv else { return }

        self.sender = Sender(walletManager: self.walletManager, kvStore: kvStore, store: self.store)
        
        sender?.sendToCard(amount: litoshis,
                           toAddress: address) { didSend in
                 completion(didSend)
        }
    }
}


