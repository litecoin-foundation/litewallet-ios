//
//  TransferAmountViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/17/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import KeychainAccess

class TransferAmountViewModel: ObservableObject {
      
    //MARK: - Combine Variables
    @Published
    var transferAmountString: String = ""
    
    @Published
    var newBalanceString: String = ""
    
    @Published
    var walletType: WalletType
     
    @Published
    var walletStatus: WalletBalanceStatus
    
    //MARK: - Private Variables
    private let keychain = Keychain(service: "com.litecoincard.service")
     
    //MARK: - Public Variables 
    var litewalletBalance: Double =  0.0
    
    var litewalletAddress: String = ""
    
    var cardBalance: Double = 0.0
    
    var cardAddress: String = ""
    
    var currentBalance: Double = 0.0
    
    /// This is the LTC address the wallet is sending LTC TO
    var destinationAddress: String {
        return walletType == .litewallet ? cardAddress : litewalletAddress
    }
    
    var transferAmount: Double {
        return Double(transferAmountString) ?? 0.0
    }

    init(walletType: WalletType,
         walletStatus: WalletBalanceStatus,
         litewalletBalance: Double,
         litewalletAddress: String,
         cardBalance: Double,
         cardAddress: String) {
        
        self.walletType = walletType
        
        self.walletStatus = walletStatus
        
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
        
    
        
    }
    
    /// Transfer Litecoin from **Litewallet to Litecoin Card**
    /// - Parameters:
    ///   - amount: Litecoin to 6 decimal places
    ///   - completion: To complete process
    ///   - address: Destination Litecoin address
    func transferToCard(amount: Double,
                        address: String,
                        completion: @escaping () -> Void) {
        
        print("XX Transfer to Card:\n")
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
     
}
 
