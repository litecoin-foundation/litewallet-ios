@testable import litewallet
import XCTest

class BRAddressTests: XCTestCase {
	private let walletManager: WalletManager = try! WalletManager(store: Store(), dbPath: nil)
	var newAddress: String = ""

	func testNewAddressGeneration() throws {
		if let address = walletManager.wallet?.receiveAddress {
			newAddress = address
			XCTAssertTrue(newAddress == "")
			XCTAssertTrue(newAddress.isValidAddress)
		} else {
			XCTAssertNil(walletManager.wallet?.receiveAddress)
		}
	}
}
