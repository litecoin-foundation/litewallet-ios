//
//  MockSeeds.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/15/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI

//Draft list of mock data to inject into tests
struct MockSeeds {
      static let date100 = Date(timeIntervalSince1970: 1000)
      static let rate100 = Rate(code: "USD", name: "US Dollar", rate: 43.3833, lastTimestamp: date100)
      static let amount100 = Amount(amount: 100, rate: rate100, maxDigits: 4443588634)
    
    
}

struct MockData {
    static let cardImage: Image = Image("litecoin-card-front")
    static let cardImageString: String = "litecoin-card-front"
    static let logoImageString: String = "coinBlueWhite"
    static let smallBalance: Float = 0.055
    static let largeBalance: Float = 485.05934938
}
