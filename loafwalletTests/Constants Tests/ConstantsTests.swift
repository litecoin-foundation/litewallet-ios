//
//  ConstantsTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 11/14/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet
 
class ConstantsTests: XCTestCase {
 
    func testLFDonationAddressPage() throws {
        XCTAssertTrue(FoundationSupport.dashboard == "https://litecoinfoundation.zendesk.com/")
	}
}
