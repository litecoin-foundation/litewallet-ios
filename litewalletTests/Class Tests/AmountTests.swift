@testable import litewallet
import XCTest

class AmountTests: XCTestCase {
	let mockSeeds = MockSeeds()

	override func setUp() {}

	override func tearDown() {}

	func testAmountString() {}

	func testAmountForLtcFormat() {
		// Given:
		let amount = MockSeeds.amount100

		// Then:
		XCTAssertTrue(amount.amount == 100)
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		measure {
			// Put the code you want to measure the time of here.
		}
	}
}
