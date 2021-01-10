//
//  TransactionsViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/20/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation

class TransactionsViewModel: ObservableObject {
    
    var store: Store
    
    var walletManager: WalletManager
    
    var isLTCSwapped: Bool  = false
      
    init(store: Store, walletManager: WalletManager) {
        
        self.store = store
        self.walletManager = walletManager
        self.isLTCSwapped = store.state.isLtcSwapped
    }
}

