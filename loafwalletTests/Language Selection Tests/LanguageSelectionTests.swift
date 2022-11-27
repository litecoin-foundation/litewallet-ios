//
//  LanguageSelectionTests.swift
//  loafwalletTests
//
//  Created by Ivan Ferencak on 27.11.2022..
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

final class LanguageSelectionTests: XCTestCase {

    let viewModel = LanguageSelectionViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel.setLanguage(code: "en")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel.setLanguage(code: "en")
    }

    func testIfLanguagesExist() throws {
        XCTAssert(viewModel.localizations.count > 0)
    }

    func testLanguageChange() throws {
        let initialLanguage = UserDefaults.selectedLanguage
        XCTAssertEqual(initialLanguage, "en")

        let spannish = "es"
        viewModel.setLanguage(code: spannish)
        XCTAssertEqual(spannish, UserDefaults.selectedLanguage)
        XCTAssertEqual(S.LitewalletAlert.warning.localize(), "Aviso")
    }

}
