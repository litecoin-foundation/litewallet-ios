//
//  SendAddressHostingController.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/21/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI

class SendAddressHostingController: UIHostingController<SendAddressCellView> {
    
    var addressString: String = ""
    
    let contentView = SendAddressCellView()

    init() {
        
        addressString = contentView.viewModel.addressString
        super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    func didUpdateAddressString() {
        addressString = contentView.viewModel.addressString
    }

}
