//
//  PreTransferViewModelTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 8/16/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
import Foundation
import SwiftUI
import UIKit

@testable import loafwallet

class PreTransferViewModelTests: XCTestCase {
    
    var viewModel: PreTransferViewModel!
    
    let smallBalance: Double = 0.0044
    
    let bigBalance: Double = 52250.225
    
    var walletType: WalletType = .litecoinCard
    
    override func setUp() {
        super.setUp()
        
        viewModel = PreTransferViewModel(walletType: walletType,
                                         balance: smallBalance)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testWalletTypeLitecoinCardDescription() throws {
        
        walletType = .litecoinCard
        
        let failName = "Noname"
        
        let uiImageFail = UIImage(named: failName)
        
        XCTAssertNil(uiImageFail)
        
        let uiImageSuccess = UIImage(named: walletType.description)
        
        if let size = uiImageSuccess?.size {
            
            XCTAssertNotNil(size.width > 0, "Litecoin Card image was found")
        }
        else {
            XCTFail("Fail to find Image")
        }
    }
    
    func testWalletTypeLitewalletDescription() throws {
        
        walletType = .litewallet
        
        let failName = "Noname"
        
        let uiImageFail = UIImage(named: failName)
        
        XCTAssertNil(uiImageFail)
        
        let uiImageSuccess = UIImage(named: walletType.description)
        
        if let size = uiImageSuccess?.size {
            
            XCTAssertNotNil(size.width > 0, "Litewallet image was found")
        }
        else {
            XCTFail("Fail to find Image")
        }
    }

}
