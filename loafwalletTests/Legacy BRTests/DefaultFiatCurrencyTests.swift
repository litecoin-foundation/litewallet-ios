//  DefaultCurrencyTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 6/11/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//
  
import XCTest
@testable import loafwallet

class DefaultCurrencyTests : XCTestCase {
    
    let defaultLocalCurrency = Locale(identifier: "en_US")
    
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "defaultcurrency")
    }
    
    func testUpdateEUR() {
        UserDefaults.defaultCurrencyCode = "EUR"
        XCTAssertTrue(UserDefaults.defaultCurrencyCode == "EUR", "Default currency should update.")
    }
    
    func testUpdateJPY() {
        UserDefaults.defaultCurrencyCode = "JPY"
        XCTAssertTrue(UserDefaults.defaultCurrencyCode == "JPY", "Default currency should update.")
    }
    
    func testAction() {
        UserDefaults.defaultCurrencyCode = "USD"
        let store = Store()
        store.perform(action: DefaultCurrency.setDefault("CAD"))
        XCTAssertTrue(UserDefaults.defaultCurrencyCode == "CAD", "Actions should persist new value")
    }
}

