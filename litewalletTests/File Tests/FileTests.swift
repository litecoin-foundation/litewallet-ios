//
//  FileTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 5/6/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//
import Firebase
@testable import litewallet
import XCTest

class FileTests: XCTestCase {
	func testGoogleServicesFileExists() throws {
		let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")

		XCTAssertNotNil(FirebaseOptions(contentsOfFile: filePath!))
	}
}
