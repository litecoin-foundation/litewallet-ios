import Foundation
@testable import loafwallet
import SwiftUI
import XCTest

class TransferAmountViewModelTests: XCTestCase {
	var lwPlusviewModel: TransferAmountViewModel!

	var lwlcPlusviewModel: TransferAmountViewModel!

	var cardPlusviewModel: TransferAmountViewModel!

	let walletManager = try! WalletManager(store: Store())

	override func setUp() {
		super.setUp()

		lwPlusviewModel = TransferAmountViewModel(walletType: .litewallet,
		                                          litewalletBalance: 520.0,
		                                          litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
		                                          cardBalance: 0.0,
		                                          cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu",
		                                          walletManager: walletManager,
		                                          store: Store())

		lwlcPlusviewModel = TransferAmountViewModel(walletType: .litewallet,
		                                            litewalletBalance: 520.0,
		                                            litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
		                                            cardBalance: 0.658,
		                                            cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu",
		                                            walletManager: walletManager,
		                                            store: Store())

		cardPlusviewModel = TransferAmountViewModel(walletType: .litecoinCard,
		                                            litewalletBalance: 0.0,
		                                            litewalletAddress: "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe",
		                                            cardBalance: 0.0555,
		                                            cardAddress: "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu",
		                                            walletManager: walletManager,
		                                            store: Store())
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
		measure {
			// Put the code you want to measure the time of here.
		}
	}
}
