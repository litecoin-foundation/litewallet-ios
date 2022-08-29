//
//  SendButtonView.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/29/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI

class SendButtonHostingController: UIHostingController<SendButtonView> {
      
    let contentView = SendButtonView()
    
    init() {
        super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
