//
//  LockScreenHeaderViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 5/15/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation

class LockScreenHeaderViewModel: ObservableObject, Subscriber {
    
    //MARK: - Combine Variables
    @Published
    var currentValueInFiat: String = ""
    
    @Published
    var currencyCode: String = ""
    
    //MARK: - Public Variables
    var store: Store?
    
    init(store: Store) {
        
        self.store = store
        
        addSubscriptions()
        fetchCurrentPrice()
    }
    
    private func fetchCurrentPrice() {
        
        guard let currentRate = self.store?.state.currentRate else {
            print("Error: Rate not fetched")
            return
        }
        
        // Price Label
        let fiatRate = Double( round ( 100 * currentRate.rate / 100))
        let formattedFiatString = String(format: "%.02f", fiatRate)
        currencyCode = currentRate.code
        let currencySymbol = Currency.getSymbolForCurrencyCode(code: currencyCode) ?? ""
        currentValueInFiat = String(currencySymbol + formattedFiatString)
    }
    
    // MARK: - Add Subscriptions
    private func addSubscriptions() {
        
        guard let store = self.store else {
            NSLog("ERROR: Store not initialized")
            return
        }
        
        store.subscribe(self, selector: { $0.currentRate != $1.currentRate},
                        callback: { _ in
                            self.fetchCurrentPrice()
                        })
        
    }
}

