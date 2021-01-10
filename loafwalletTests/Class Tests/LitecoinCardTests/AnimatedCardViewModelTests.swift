//
//  AnimatedCardViewModelTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 1/8/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
import Foundation
import SwiftUI
@testable import loafwallet

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
