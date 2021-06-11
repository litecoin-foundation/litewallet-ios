//
//  TabBarViewControllerTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 6/11/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

class TabBarViewControllerTests: XCTestCase {
    
    var viewController: TabBarViewController!
    
    override func setUpWithError() throws {
        
        viewController = UIStoryboard.init(name: "Main",
                                           bundle: nil)
            .instantiateViewController(withIdentifier: "TabBarViewController") as?
            TabBarViewController
        
        viewController.loadViewIfNeeded()
        
    }
    
    override func tearDownWithError() throws {
        viewController = nil
    }
    
    func testTabBarItemCount() throws {
        
        // There should be 5 tabs in this version for US users
        
        XCTAssertTrue(viewController.tabBar.items?.count == 5)
    }
    
    func testTabBarItemRange() throws {
        
        //Using a tag is risky and this tests that the tab has the correct tag
        
        XCTAssertTrue(viewController.tabBar.items?[0].tag == 0)
        
        XCTAssertTrue(viewController.tabBar.items?[1].tag == 1)
        
        XCTAssertTrue(viewController.tabBar.items?[2].tag == 2)
        
        XCTAssertTrue(viewController.tabBar.items?[3].tag == 3)
        
        XCTAssertTrue(viewController.tabBar.items?[4].tag == 4)
        
        
    }
    
}

