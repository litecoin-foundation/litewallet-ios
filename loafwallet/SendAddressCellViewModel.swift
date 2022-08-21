//
//  SendAddressCellViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/16/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation

class SendAddressCellViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    @Published
    var addressString: String = ""
    
    @Published
    var didUpdatePaste: Bool = false

    //MARK: - Public Variables
    var shouldPasteAddress: (() -> Void)?
    
    var shouldScanAddress: (() -> Void)?
     
    init() {
        
    }
    
}

