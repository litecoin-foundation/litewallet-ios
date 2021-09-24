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
    
<<<<<<< HEAD
    //MARK: - Combine Variables
=======
>>>>>>> main
    @Published
    var emailString: String = ""
    
    @Published
    var passwordString: String = ""
<<<<<<< HEAD
         
    @Published
    var tokenString: String = ""
    
=======
    
    //MARK: - Login Status
>>>>>>> main
    @Published
    var isLoggedIn: Bool = false
    
    @Published
    var doShowModal: Bool = false
    
    @Published
    var didCompleteLogin: Bool = false
    
<<<<<<< HEAD
    @Published
    var processMessage: String = S.LitecoinCard.login + " ..."

    //MARK: - Private Variables
    private let keychain = Keychain(service: "com.litecoincard.service")
    
    init() {
    }
	
    func simpleCredentialsCheck() -> Bool {
        return (emailString.isEmpty && passwordString.isEmpty)
    }
    
=======
>>>>>>> main
    func login(completion: @escaping (Bool) -> ()) {
        
        //Turn on the modal
        self.doShowModal = false
        
<<<<<<< HEAD
        let credentials: [String: Any] = ["email": emailString,
                                          "password": passwordString,
                                          "token": tokenString]
        
         PartnerAPI.shared.loginUser(credentials: credentials) { dataDictionary in
=======
        let credentials: [String: Any] = ["email": emailString, "password": passwordString]
        
        PartnerAPI.shared.loginUser(credentials: credentials) { dataDictionary in
>>>>>>> main
            
            if let error = dataDictionary?["error"] as? String {
                
                DispatchQueue.main.async {
<<<<<<< HEAD
                    
                    print("ERROR: Login failure: \(error.description)")
        
=======
                    print("ERROR: Login failure: \(error.description)")
>>>>>>> main
                    self.isLoggedIn = false
                    self.didCompleteLogin = false
                    completion(self.didCompleteLogin)
                }
            }
            
<<<<<<< HEAD
=======
            let cardService = "com.litecoincard.service"
            let keychain = Keychain(service: cardService)
            
>>>>>>> main
            if let responeDict = dataDictionary,
               let token = responeDict["token"] as? String,
               let userID = responeDict["uuid"] as? String,
               let email = credentials["email"] as? String,
               let password = credentials["password"] as? String {
                
<<<<<<< HEAD
                self.keychain[email] = password
                self.keychain["userID"] = userID
                self.keychain["token"] = token
				
=======
                keychain[email] = password
                keychain["userID"] = userID
                keychain["token"] = token
                
>>>>>>> main
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
