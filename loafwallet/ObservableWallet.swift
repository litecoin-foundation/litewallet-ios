//
//  ObservableWallet.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation

class ObservableWallet: ObservableObject, Subscriber {
    
    //MARK: - Combine Variables
//    @Published
//    var amount = Amount(amount: 0, rate: Rate.empty, maxDigits: 6)
//
//    @Published
//    var balance: Double = 0.0
//
//    @Published
//    var balanceInt: UInt64 = 0
    
    //MARK: - Public Variables
    
    //MARK: - Private Variables
    private var store:  Store
    
    private var walletManager: WalletManager
    
    init(store: Store,
         walletManager: WalletManager) {
         
        self.store = store
        
        self.walletManager = walletManager
          
        if let balance = walletManager.wallet?.balance,
           let rate =  store.state.currentRate {
            
//            self.amount = Amount(amount: balance,
//                                            rate: rate,
//                                            maxDigits: 8)
            
        }
         
        addSubscriptions()
    }
    
    // MARK: - Add Subscriptions
    private func addSubscriptions() {
        
        store.subscribe(self,
                        selector: { $0.currentRate != $1.currentRate},
                        callback: {
                            if let rate = $0.currentRate {
                               // self.amount = Amount(amount: 0, rate: rate, maxDigits: 4)
                            }
                        })
        
        
        store.subscribe(self,
                        selector: {$0.walletState.balance != $1.walletState.balance },
                        callback: { state in
                            if let balanceInt = state.walletState.balance {
//                                self.balanceInt = balanceInt
//                                self.balance = self.amount.amountForLtcFormat
//                                print("XXX OW  Changed \(self.balance)")
                            } })
        
    }
    
}


