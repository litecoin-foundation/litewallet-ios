//
//  SendUIHostingController.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/4/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


class SendUIHostingController : UIHostingController<SendSwiftUIView> {
    
    @ObservedObject
    var sendViewModel = SendSwiftUIViewModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SendSwiftUIView(isReadyToSend: .constant(false)))
    }
    

}
