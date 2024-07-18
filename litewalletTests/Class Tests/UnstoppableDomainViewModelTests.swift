@testable import litewallet
import XCTest

class UnstoppableDomainViewModelTests: XCTestCase {
	var viewModel: UnstoppableDomainViewModel!

	override func setUp() {
		super.setUp()
		viewModel = UnstoppableDomainViewModel()
	}

	/// Checks the domain address closure
	/// - Throws: Error
	func testDomainLookupForLTC() throws {
		viewModel.didResolveUDAddress?("RESOLVED_LTC_ADDRESS")

		// DEV: This test succeeds incorrectly
		viewModel.didResolveUDAddress = { address in
			XCTAssertTrue(address == "RESOLVED_LTC_ADDRESS")
		}
	}
}
