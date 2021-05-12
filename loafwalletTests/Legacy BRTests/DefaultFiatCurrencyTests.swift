 //  DefaultCurrencyTests.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-04-06.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import XCTest
 @testable import loafwallet

class DefaultCurrencyTests : XCTestCase {
    
    let defaultLocalCurrency = Locale(identifier: "en_US")

    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "defaultcurrency")
    }

    func testInitialValue() {
                
        XCTAssertTrue(defaultLocalCurrency.currencyCode ==
                        UserDefaults.defaultCurrencyCode,
                      "Default currency should be equal to the local currency (USD) by default")
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
