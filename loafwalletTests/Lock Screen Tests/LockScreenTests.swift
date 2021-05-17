//
//  LockScreenTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 5/16/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

class LockScreenTests: XCTestCase {
    
    func testLockScreenHeaderView() throws {
        
        let viewModel = LockScreenHeaderViewModel(store: Store())
         
        XCTAssertNotNil(viewModel.currencyCode)
    }
}
