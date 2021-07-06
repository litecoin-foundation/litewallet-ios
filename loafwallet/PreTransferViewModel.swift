//
//  PreTransferViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/6/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI

class PreTransferViewModel: ObservableObject {
    
    enum WalletType: String {
        case litecoinCard
        case litewallet
        
        var description: String {
            switch self {
                case .litecoinCard:
                    return "litecoin-card-front"
                case .litewallet:
                    return "coinBlueWhite"
            }
        }
 
        var balanceLabel: String {
            switch self {
                case .litecoinCard:
                    return "Litecoin Card Balance:"
                case .litewallet:
                    return "Litewallet Balance:"
            }
        }
            
    }
        
    //MARK: - Public Parameters
    
    var walletType: WalletType
    
    var balance: Float
    
    init(walletType: WalletType, balance: Float) {
        
        self.walletType = walletType
        
        self.balance = balance
    }
}




