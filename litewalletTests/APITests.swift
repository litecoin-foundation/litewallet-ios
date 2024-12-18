@testable import litewallet
import XCTest

class APITests: XCTestCase {
	var apiServer: APIServer!
	var apiClient: BRAPIClient!

	override func setUpWithError() throws {
		apiServer = APIServer()
		apiClient = litewallet.BRAPIClient(authenticator: NoAuthAuthenticator())
	}

	override func tearDownWithError() throws {
		apiServer = nil
	}

	func testfetchExchangeRates() throws {
		apiClient.exchangeRates { rates, _ in
			for rate in rates {
				if rate.code == "AFN" {
					XCTAssertEqual(rate.name, "Afghan Afghani")
				}
				if rate.code == "GBP" {
					XCTAssertEqual(rate.name, "British Pound Sterling")
				}
				if rate.code == "EUR" {
					XCTAssertEqual(rate.name, "Euro")
				}
				if rate.code == "USD" {
					XCTAssertEqual(rate.name, "US Dollar")
				}
			}
		}
	}

	func testfeePerKb() throws {
		apiClient.feePerKb { fees, _ in
			XCTAssertGreaterThan(fees.economy, 0)
			XCTAssertGreaterThan(fees.regular, 0)
			XCTAssertGreaterThan(fees.luxury, 0)
		}
	}
}
