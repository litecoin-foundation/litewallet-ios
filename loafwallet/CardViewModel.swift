//
//  CardViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import KeychainAccess

class CardViewModel: ObservableObject {
        
    //MARK: - Login Status
    @Published
    var isLoggedIn: Bool = false
    
    @Published
    var isNotRegistered: Bool = true
      
    //MARK: - Combine Variables
    @Published
    var cardWalletDetails: CardWalletDetails?
    
    @Published
    var litewalletBalance: Double = 0.0
      
    //MARK: - Public Variables
    var walletManager: WalletManager
    
    var store: Store
     
    init(walletManager: WalletManager,
         store: Store) {
        
        self.walletManager = walletManager
        
        self.store = store
        
        calculatedLitewalletBalance()
    }
    
    func calculatedLitewalletBalance() {
        
        if let balance = walletManager.wallet?.balance ,
           let rate =  store.state.currentRate {
            
            self.litewalletBalance = Amount(amount: balance,
                                            rate: rate,
                                            maxDigits: store.state.maxDigits).amountForLtcFormat
        }
    }
    
    /// Fetch Card Wallet details from the Ternio server
    /// - Parameter completion: All is well
    func fetchCardWalletDetails(completion: @escaping () -> Void) {
         
        let keychain = Keychain(service: "com.litecoincard.service")
          
        // Fetches the latest token and UserID
        guard let token = keychain["token"] ,
              let userID = keychain["userID"] else {
            LWAnalytics.logEventWithParameters(itemName:._20210804_ERR_KLF)
            return
        }
         
        PartnerAPI.shared.getWalletDetails(userID: userID, token: token) { detailsDict in
            
            //Only receives the data element there is the metadata
            guard let data = detailsDict?["data"] as? [String: Any] else {
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF)
                return
            }
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: data, options:[])
                
                let decoder = JSONDecoder() 
                
                let walletDetails = try? decoder.decode(CardWalletDetails.self, from: jsonData)
                
                DispatchQueue.main.async { 
                    self.cardWalletDetails = walletDetails
                    LWAnalytics.logEventWithParameters(itemName:._20210804_TAWDS)
                }
                
            } catch {
                print("Error: Incomplete dictionary data from partner API")
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF) 
            }
        }
    }
}
