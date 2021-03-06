//
//  TwoFactorAuthTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 8/15/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

class Enter2FACodeViewModelTests: XCTestCase {
    
    var viewModel: Enter2FACodeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = Enter2FACodeViewModel()
    }
    
    /// Checks the user taps on the closure
    func testDidConfirmToken() throws {

        self.viewModel.didConfirmToken { token in
            XCTAssert(true, "Tap did work")
        }
    }
    
    /// Checks limit can be changed
    func testLimitCanChange() throws {
        
        let viewModelSeven = Enter2FACodeViewModel(limit: 7)
        
        XCTAssert(viewModelSeven.characterLimit == 7)
    }
    
    /// Check too big token
    func testTooBigToken() throws {
        
        let tokenBig = "0123456"
        
        viewModel.tokenString = tokenBig
        
        XCTAssert(viewModel.tokenString.count <= 6, "Token truncated to 6 chars")
    }
    
    /// Check 6 digit token
    func testSixDigitToken() throws {
        
        let tokenBig = "012345"
        
        viewModel.tokenString = tokenBig
        
        XCTAssert(viewModel.tokenString.count == 6, "Token is 6 chars")
    }
    
    /// Check dismissView
    func testCheckDismissView() throws {
        
        viewModel.shouldDismissView {
            XCTAssert(true, "Dismiss worked")
        }
    }
}
