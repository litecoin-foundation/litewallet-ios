//
//  LoginViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/31/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import KeychainAccess

class LoginViewModel: ObservableObject {
    
    @Published
    var emailString: String = ""
    
    @Published
    var passwordString: String = ""
    
    //MARK: - Login Status
    @Published
    var isLoggedIn: Bool = false
    
    @Published
    var doShowModal: Bool = false
    
    @Published
    var didCompleteLogin: Bool = false
    
    func login(completion: @escaping (Bool) -> ()) {
        
        //Turn on the modal
        self.doShowModal = false
        
        let credentials: [String: Any] = ["email": emailString, "password": passwordString]
        
        PartnerAPI.shared.loginUser(credentials: credentials) { dataDictionary in
            
            if let error = dataDictionary?["error"] as? String {
                
                DispatchQueue.main.async {
                    print("ERROR: Login failure: \(error.description)")
                    self.isLoggedIn = false
                    self.didCompleteLogin = false
                    completion(self.didCompleteLogin)
                }
            }
            
            let cardService = "com.litecoincard.service"
            let keychain = Keychain(service: cardService)
            
            if let responeDict = dataDictionary,
               let token = responeDict["token"] as? String,
               let userID = responeDict["uuid"] as? String,
               let email = credentials["email"] as? String,
               let password = credentials["password"] as? String {
                
                keychain[email] = password
                keychain["userID"] = userID
                keychain["token"] = token
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                    self.isLoggedIn = true
                    self.didCompleteLogin = true
                    
                    //Turn modal off
                    self.doShowModal = false
                    
                    NotificationCenter.default.post(name: .LitecoinCardLoginNotification, object: nil,
                                                    userInfo: nil)
                    completion(self.didCompleteLogin)
                }
            }
        }
    }
}
