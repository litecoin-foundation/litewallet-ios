//
//  SendSwiftUIViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/4/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class SendSwiftUIViewModel: ObservableObject {
    
    //MARK: - Combine Variables
        @Published
        var isDomainResolving: Bool = false
    @Published
    var searchString: String = ""
    
    @Published
    var memoString: String = ""
    
    
    
//    @Published
//    var searchString: String = ""
//
//    @Published
//    var placeholderString: String = S.Send.UnstoppableDomains.placeholder
//

    
    //MARK: - Public Variables
//    var didResolveUDAddress: ((String) -> Void)?
//
//    var shouldClearAddressField: (() -> Void)?
//
//    var didFailToResolve: ((String) -> Void)?
    
    //MARK: - Private Variables
//    private var ltcAddress = ""
//    private var dateFormatter: DateFormatter? {
//
//        didSet {
//            dateFormatter = DateFormatter()
//            dateFormatter?.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        }
//    }
    
    init() { }
    
     
}
