//
//  EmailValidation.swift
//  loafwallet
//
//  Created by Kerry Washington on 9/25/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation

class EmailValidation {
    
    class func isEmailValid(emailString: String) -> Bool {
        if try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$",
                                    options: .caseInsensitive)
                    .firstMatch(in: emailString,
                                options: [],
                                range: NSRange(location: 0,
                                               length: emailString.count)) == nil {
            return false
        } else {
            return true
        }
    }
}
