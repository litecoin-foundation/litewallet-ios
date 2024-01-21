@testable import litewallet
import XCTest

class LockScreenTests: XCTestCase {
	func testLockScreenHeaderView() throws {
		let viewModel = LockScreenViewModel(store: Store())

		XCTAssertNotNil(viewModel.currencyCode)
	}
}
