import Foundation
@testable import loafwallet
import SwiftUI
import XCTest

class AnimatedCardViewModelTests: XCTestCase {
	var viewModel: AnimatedCardViewModel!

	override func setUp() {
		super.setUp()
		viewModel = AnimatedCardViewModel()
	}

	func testCardImageFrontIsFound() throws {
		let image = Image(viewModel.imageFront)
		XCTAssertNotNil(image)
	}
}
