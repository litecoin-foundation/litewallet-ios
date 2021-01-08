//
//  RegistrationViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/24/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import KeychainAccess

enum UserDataType {
    case genericString
    case email
    case country
    case mobileNumber
    case password
    case confirmation
}

class RegistrationViewModel: ObservableObject {
    
    @Published
    var isRegistering: Bool = false
    
    @Published
    var didRegister: Bool = false
    
    @Published
    var message: String = S.LitecoinCard.registeringUser
    
    var dataDictionary = [String: Any]()
    
    init() {
        
    }
    
    func verify(data: [String: Any],
                completion: @escaping (Bool) -> ()) {
        
        if  self.isDataValid(dataType: .genericString, data: (dataDictionary["firstname"] as! String)) &&
                isDataValid(dataType: .genericString, data: (dataDictionary["lastname"] as! String)) &&
                isDataValid(dataType: .email, data: (dataDictionary["email"] as! String)) &&
                isDataValid(dataType: .password, data: (dataDictionary["password"] as! String)) &&
                isDataValid(dataType: .mobileNumber, data: (dataDictionary["phone"] as! String)) &&
                isDataValid(dataType: .country, data: (dataDictionary["country"] as! String)) &&
                isDataValid(dataType: .genericString, data: (dataDictionary["state"] as! String)) &&
                isDataValid(dataType: .genericString, data: (dataDictionary["city"] as! String)) &&
                isDataValid(dataType: .genericString, data: (dataDictionary["address1"] as! String)) &&
                isDataValid(dataType: .genericString, data: (dataDictionary["zip_code"] as! String)) {
            
            self.isRegistering = true
            
            completion(isRegistering)
        }
    }
    
    func registerCardUser() {
        
        var setupUserID: String?
        
        PartnerAPI.shared.createUser(userDataParams: dataDictionary) { (newUser) in
        
            if let userID = newUser?.userID,
               let createdAt = newUser?.createdAtDateString {
                
                ///Move  setupUserID
                setupUserID = userID
     
                guard let password = self.dataDictionary["password"] as? String else { return }
                guard let email = self.dataDictionary["email"] as? String else { return }
                
                let cardService = "com.litecoincard.service"
                let keychain = Keychain(service: cardService)
                
                keychain[email] = password
                keychain["userID"] = userID
                keychain["createdAt"] = createdAt
                
                DispatchQueue.main.async {
                    self.message = S.LitecoinCard.registrationSuccess
                    self.didRegister = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.isRegistering = false
                    }
                }
            }
       }
     
        if setupUserID == nil {
            DispatchQueue.main.async {
                self.message = S.LitecoinCard.registrationFailure
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.isRegistering = false
                }
            }
        }
    }
    
    func isDataValid(dataType: UserDataType, firstString: String = "", data: Any) -> Bool {
        
        switch dataType {
            case .genericString:
                return isGenericStringValid(genericString: (data as! String))
            case .email:
                return isEmailValid(emailString: (data as! String))
            case .country:
                return (data as! String) == "US" ?  true : false
            case .mobileNumber:
                return isMobileNumberValid(mobileString: (data as! String))
            case .password:
                return isPasswordValid(passwordString: (data as! String))
            case .confirmation:
                return isConfirmedValid(firstString: firstString, confirmingString: (data as! String))
        }
    }
    
    //MARK: - Data Validators
    
    func isGenericStringValid(genericString: String) -> Bool {
        
        guard genericString != "" else {
            return false
        }
        
        guard genericString.count <= 32 else {
            return false
        }
        
        return true
    }
    
    func isConfirmedValid(firstString: String, confirmingString: String) -> Bool {
        return firstString == confirmingString ? true : false
    }
    
    func isEmailValid(emailString: String) -> Bool {
        
        if try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive)
            .firstMatch(in: emailString, options: [],
                        range: NSRange(location: 0,
                                       length: emailString.count)) == nil {
            return false
        } else {
            return true
        }
    }
    
    /// Password  Validator
    /// - Parameter passwordString: 6 - 10 chars
    /// - Returns: Bool
    func isPasswordValid(passwordString: String) -> Bool {
        
        guard passwordString != "" else {
            return false
        }
        
        guard (passwordString.count >= 6 && passwordString.count <= 10) else {
            return false
        }
        
        if try! NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$", options: .caseInsensitive)
            .firstMatch(in: passwordString, options: [],
                        range: NSRange(location: 0,
                                       length: passwordString.count)) == nil {
            return false
        } else {
            return true
        }
    }
    
    /// Mobile Number Validator
    /// - Parameter mobileString: 10+ integers 0 - 9
    /// - Returns: Bool
    func isMobileNumberValid(mobileString: String) -> Bool {
        guard mobileString != "" else {
            return false
        }
        
        //https://boards.straightdope.com/t/longest-telephone-number-in-the-world/400450
        guard (mobileString.count >= 10 && mobileString.count <= 20) else {
            return false
        }
        
        if try! NSRegularExpression(pattern: "^[0-9]*$", options: .caseInsensitive)
            .firstMatch(in: mobileString, options: [],
                        range: NSRange(location: 0,
                                       length: mobileString.count)) == nil {
            return false
        } else {
            return true
        }
    }
}


