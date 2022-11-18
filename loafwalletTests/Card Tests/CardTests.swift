//
//  CardTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 5/9/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//
//
import Firebase
@testable import loafwallet
import XCTest

class CardTests: XCTestCase {
	var sharedAppDelegate = AppDelegate()

	func testCheckUserIsExUSA() throws {
		let 🇲🇽 = Locale(identifier: "mx_MX")
		let 🇮🇩 = Locale(identifier: "id_ID")
		let 🇷🇺 = Locale(identifier: "ru_RU")
		let 🇧🇷 = Locale(identifier: "br_BR")
		let 🇹🇷 = Locale(identifier: "tr_TR")
		let 🇨🇳 = Locale(identifier: "cn_CN")
		let 🇯🇵 = Locale(identifier: "jp_JP")
		let 🇪🇸 = Locale(identifier: "es_ES")
		let 🇩🇪 = Locale(identifier: "de_DE")

		let arrayOfLocales = [🇲🇽, 🇮🇩, 🇷🇺, 🇧🇷, 🇹🇷, 🇨🇳, 🇯🇵, 🇪🇸, 🇩🇪]

		arrayOfLocales.forEach { locale in
			sharedAppDelegate.updateCurrentUserLocale(localeId: locale.identifier)
			XCTAssertFalse(UserDefaults.userIsInUSA)
		}
	}

	func testCheckUserIsBilingualInUSA() throws {
		let 🇺🇸 = Locale(identifier: "en_US")
		let 🇲🇽🇺🇸 = Locale(identifier: "mx_US")
		let 🇮🇩🇺🇸 = Locale(identifier: "id_US")
		let 🇷🇺🇺🇸 = Locale(identifier: "ru_US")
		let 🇧🇷🇺🇸 = Locale(identifier: "br_US")
		let 🇹🇷🇺🇸 = Locale(identifier: "tr_US")
		let 🇨🇳🇺🇸 = Locale(identifier: "cn_US")
		let 🇯🇵🇺🇸 = Locale(identifier: "jp_US")
		let 🇪🇸🇺🇸 = Locale(identifier: "es_US")
		let 🇩🇪🇺🇸 = Locale(identifier: "de_US")

		let arrayOfLocales = [🇺🇸, 🇲🇽🇺🇸, 🇮🇩🇺🇸, 🇷🇺🇺🇸, 🇧🇷🇺🇸, 🇹🇷🇺🇸, 🇨🇳🇺🇸, 🇯🇵🇺🇸, 🇪🇸🇺🇸, 🇩🇪🇺🇸]

		arrayOfLocales.forEach { locale in
			sharedAppDelegate.updateCurrentUserLocale(localeId: locale.identifier)
			XCTAssertTrue(UserDefaults.userIsInUSA)
		}
	}
}
