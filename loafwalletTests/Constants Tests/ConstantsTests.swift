@testable import loafwallet
import XCTest

class ConstantsTests: XCTestCase {
	func testLFDonationAddressPage() throws {
		XCTAssertTrue(FoundationSupport.dashboard == "https://litecoinfoundation.zendesk.com/")
	}
}
