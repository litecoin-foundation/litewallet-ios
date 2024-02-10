@testable import litewallet
import XCTest

class DefaultCurrencyTests: XCTestCase {
	let defaultLocalCurrency = Locale(identifier: "en_US")

	override func setUp() {
		UserDefaults.standard.removeObject(forKey: "defaultcurrency")
	}

	func testUpdateEUR() {
		UserDefaults.defaultCurrencyCode = "EUR"
		XCTAssertTrue(UserDefaults.defaultCurrencyCode == "EUR", "Default currency should update.")
	}

	func testUpdateJPY() {
		UserDefaults.defaultCurrencyCode = "JPY"
		XCTAssertTrue(UserDefaults.defaultCurrencyCode == "JPY", "Default currency should update.")
	}

	func testAction() {
		UserDefaults.defaultCurrencyCode = "USD"
		let store = Store()
		store.perform(action: DefaultCurrency.setDefault("CAD"))
		XCTAssertTrue(UserDefaults.defaultCurrencyCode == "CAD", "Actions should persist new value")
	}
}
