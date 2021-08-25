//
//  CardTwoFactor.swift
//  loafwallet
//
//  Created by Kerry Washington on 8/19/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import KeychainAccess

class CardTwoFactor: ObservableObject {
     
    //MARK: - Combine Variables
    @Published
    var isEnabled: Bool = true {
        
        didSet {
            
            // Using the Bool > Int > String as a quick hack
            // since the Keychain Access framework doesnt have a bool value
            
            let keychainStatus = keychain["shouldEnable2FA"]
            
            if isEnabled {
                
                if keychainStatus == "0" {
                    
                    keychain["shouldEnable2FA"] = "1"
                     
                    self.update2FAPreference()
                }
            }
            else {
                
                if keychainStatus == "1" {
                    
                    keychain["shouldEnable2FA"] = "0"
                      
                    self.update2FAPreference()
                }
            }
        }
    }
    
    @Published
    var errorMessage: String = ""
    
    @Published
    var errorOccured: Bool = false
        
    //MARK: - Private Variables
    private let keychain = Keychain(service: "com.litecoincard.service")
    
    init() {
        fetchUsers2FAStatus()
    }

    // Fetches the status from the keychain
    private func fetchUsers2FAStatus() {
        
        if let shouldEnable = (keychain["shouldEnable2FA"] as
                                NSString?)?.boolValue {
        
            isEnabled = shouldEnable
        }
    }
     
    // Update users 2FA preference to backend
    private func update2FAPreference() {
        
        if let userID = keychain["userID"],
           let token = keychain["token"] {
            
            PartnerAPI.shared.enable2FA(userID: userID,
                                        token: token,
                                        shouldEnable: isEnabled) { responseDict in
                
                if let response = responseDict?["response"] as? [String: Any],
                   let code = response["code"] as? Int,
                   code == 200 {
                    
                    LWAnalytics.logEventWithParameters(itemName: ._20210804_TAA2FAC)
                    
                } else if let code = responseDict?["code"] as? String,
                          let status = responseDict?["status"] as? Int,
                          code == "invalid_token",
                          status == 401 {
                                
                                self.errorMessage = S.Fragments.sorry + "" + S.LitecoinCard.twoFAErrorMessage
                                
                                self.errorOccured = true
                                
                                LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR,
                                                                   properties: ["error":"ERROR: Unauthorized Error - jwt expired, invalid_token"])
                }
            }
        }
    }

}

