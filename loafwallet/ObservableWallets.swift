//
//  ObservableWallets.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import LitewalletPartnerAPI
import KeychainAccess

class ObservableWallets: ObservableObject, Subscriber {
    
    //MARK: - Combine Variables
    @Published
    var litewalletBalance: Double = 0.0
    
    @Published
    var cardBalance: Double = 0.0
    
    //MARK: - Public Variables
    
    
    //MARK: - Private Variables
    private var store:  Store
    
    private var walletManager: WalletManager
    
    private var amount = Amount(amount: 0, rate: Rate.empty, maxDigits: 6)
 
    init(store: Store,
         walletManager: WalletManager,
         cardBalance: Double) {
         
        self.store = store
        
        self.walletManager = walletManager
        
        self.cardBalance = cardBalance
        
        loadAmount()
        
        addSubscriptions()
    }
    
    /// Load Litewallet Amount
    private func loadAmount() {
        
        if let balance = walletManager.wallet?.balance,
           let rate =  store.state.currentRate {
            
            self.amount = Amount(amount: balance,
                                 rate: rate,
                                 maxDigits: 8)
        }
        
    }
    
    /// Add Subscriptions
    private func addSubscriptions() {
        
        store.subscribe(self,
                        selector: {$0.walletState.balance != $1.walletState.balance },
                        callback: { _ in
                                self.litewalletBalance = self.amount.amountForLtcFormat
                              })
    }
    
    // MARK: - Partner API Methods
    private func fetchCardWalletBalance() {
        
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
                LWAnalytics.logEventWithParameters(itemName: ._20210405_TAWDF)
                return
            }
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: data, options:[])
                
                let decoder = JSONDecoder()
                
                let walletDetails = try? decoder.decode(CardWalletDetails.self, from: jsonData)
                guard let balance = walletDetails?.availableBalance else {
                    LWAnalytics.logEventWithParameters(itemName: ._20210405_TAWDF)
                    return
                }
                
                DispatchQueue.main.async {
                    self.cardBalance = balance
                }
                
            } catch {
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF)
            }
        }
    }

    
    
    
}


