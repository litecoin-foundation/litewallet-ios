@testable import loafwallet
import XCTest

class AmountTests: XCTestCase {
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testAmountString() {
		// Given:
		// When:
		// Then:
	}

	func testAmountForLtcFormat() {
		// Given:
		let amount = MockSeeds.amount100

		// Then:
		XCTAssertFalse(amount.amount == 0)
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		measure {
			// Put the code you want to measure the time of here.
		}
	}
}
