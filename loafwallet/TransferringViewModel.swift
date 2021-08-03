//
//  TransferringViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 7/27/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation

class TransferringViewModel : ObservableObject {
    
    
    //MARK: - Combine Variables
    @Published
    var shouldStartTransfer: Bool = false
 
    init() {  }
    
    func shouldDismissView(completion: @escaping () -> Void) {
        completion()
    }
}
