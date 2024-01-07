@testable import litewallet
import XCTest

final class ApplicationControllerTests: XCTestCase {
	var controller: ApplicationController!

	override func setUp() {
		super.setUp()
		controller = ApplicationController()
	}

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		controller = nil
	}
}
