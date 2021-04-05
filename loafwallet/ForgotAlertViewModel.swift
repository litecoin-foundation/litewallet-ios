//
//  ForgotAlertViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 4/1/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import LitewalletPartnerAPI

class ForgotAlertViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    @Published
    var emailString: String = ""
    
    @Published
    var detailMessage: String = S.LitecoinCard.resetPasswordDetail
    
    init() { }
    
    func resetPassword(completion: @escaping () -> Void) {
        
        PartnerAPI.shared.forgotPassword(email: emailString) { (responseMessage, code) in
             
            DispatchQueue.main.async {
                self.detailMessage = "\(code): " + responseMessage
                completion()
            }
        }
    }
}

