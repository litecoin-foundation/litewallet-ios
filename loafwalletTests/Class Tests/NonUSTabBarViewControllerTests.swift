//
//  NonUSTabBarViewControllerTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 6/11/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

class NonUSTabBarViewControllerTests: XCTestCase {
    var viewController: NonUSTabBarViewController!
    
    override func setUpWithError() throws {
        
        viewController = UIStoryboard.init(name: "Main",
                                           bundle: nil)
            .instantiateViewController(withIdentifier: "NonUSTabBarViewController") as?
            NonUSTabBarViewController
        
        viewController.loadViewIfNeeded()
        
        print(viewController.tabBar.items?.count)
    }
    
    
    override func tearDownWithError() throws {
        viewController = nil
    }
    
    func testTabBarItemCount() throws {
        
        // There should be 4 tabs in this version for non-US users
        
        XCTAssertTrue(viewController.tabBar.items?.count == 4)
    }
    
    func testTabBarItemRange() throws {
        
        //Using a tag is risky and this tests that the tab has the correct tag
        
        XCTAssertTrue(viewController.tabBar.items?[0].tag == 0)
        
        XCTAssertTrue(viewController.tabBar.items?[1].tag == 1)
        
        XCTAssertTrue(viewController.tabBar.items?[2].tag == 2)
        
        XCTAssertTrue(viewController.tabBar.items?[3].tag == 3)
        
    }
    
} 
