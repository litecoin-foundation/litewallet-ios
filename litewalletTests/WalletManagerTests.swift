@testable import litewallet
import XCTest

class WalletManagerTests: XCTestCase {
	private let walletManager: WalletManager = try! WalletManager(store: Store(), dbPath: nil)
	private let pin = "123456"

	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testSyncingWallet() {
		// Given:
		// When:
		// Then:
	}

	func testWalletPeerManagerDisconnection() {
		//   walletManager.peerManager?.disconnect()
	}
}
