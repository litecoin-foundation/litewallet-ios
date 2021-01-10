//
//  LoginViewModelTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 1/8/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
import Foundation
import SwiftUI
@testable import loafwallet

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    
    let mockFailingUserCreds = ["email": "myemail@com.com",
                                "password": ""]
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    func testLoginFailingCreds() throws {
        
        guard let email = mockFailingUserCreds["email"] else { return }
        
        guard let password = mockFailingUserCreds["password"] else { return }
        
        viewModel.emailString = email
        
        viewModel.passwordString = password
        
        viewModel.login { (didLogin) in
            XCTAssert(didLogin == false)
        }
    }
}

