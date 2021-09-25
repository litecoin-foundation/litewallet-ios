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
       
    //MARK: - Public Parameters
    
    var walletType: WalletType
    
    var balance: Double
      
    init(walletType: WalletType, balance: Double) {
        
        self.walletType = walletType
        
        self.balance = balance
    } 
}




