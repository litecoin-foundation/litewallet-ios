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
      
    init() { }
    
}
