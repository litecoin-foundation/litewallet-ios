@testable import loafwallet
import XCTest

class TabBarViewControllerTests: XCTestCase {
	var viewController: TabBarViewController!

	override func setUpWithError() throws {
		viewController = UIStoryboard(name: "Main",
		                              bundle: nil)
			.instantiateViewController(withIdentifier: "TabBarViewController") as?
			TabBarViewController

		viewController.loadViewIfNeeded()
	}

	override func tearDownWithError() throws {
		viewController = nil
	}

	func testTabBarItemCount() throws {
		// There should be 4 tabs in this version for all users

		XCTAssertTrue(viewController.tabBar.items?.count == 4)
	}

	func testTabBarItemRange() throws {
		// Using a tag is risky and this tests that the tab has the correct tag

		XCTAssertTrue(viewController.tabBar.items?[0].tag == 0)

		XCTAssertTrue(viewController.tabBar.items?[1].tag == 1)

		XCTAssertTrue(viewController.tabBar.items?[2].tag == 2)

		XCTAssertTrue(viewController.tabBar.items?[3].tag == 3)
	}
}
