@testable import loafwallet
import XCTest

class LockScreenTests: XCTestCase
{
	func testLockScreenHeaderView() throws
	{
		let viewModel = LockScreenHeaderViewModel(store: Store())

		XCTAssertNotNil(viewModel.currencyCode)
	}
}
