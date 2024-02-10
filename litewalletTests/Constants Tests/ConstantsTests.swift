@testable import litewallet
import XCTest

class ConstantsTests: XCTestCase {
	func testLFDonationAddressPage() throws {
		XCTAssertTrue(FoundationSupport.dashboard == "https://litecoinfoundation.zendesk.com/")
	}
}
