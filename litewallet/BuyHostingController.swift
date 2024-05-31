import Foundation
import SwiftUI

/// Moonpay: List supported countries endpoint
/// https://api.moonpay.com/v3/countries
/// - Parameter alphaCode2Char: String
/// - Parameter alphaCode3Char: String
/// - Parameter isBuyAllowed: Bool
/// - Parameter isSellAllowed: Bool
/// - Parameter countryName: String (name)
/// - Parameter isAllowedInCountry: Bool (isAllowed)
/// ===================================
/// Unused JSON parameters
/// "isNftAllowed": false
/// "isBalanceLedgerWithdrawAllowed": true,
/// "isSelfServeHighRisk": true,
/// "continent": "Asia",
/// "supportedDocuments": [
///    "passport",
///    "driving_licence",
///    "national_identity_card",
///    "residence_permit",
/// ],
/// "suggestedDocument": "national_identity_card"
/// - Returns: MoonpayCountryData
public struct MoonpayCountryData: Codable, Hashable {
	var alphaCode2Char: String
	var alphaCode3Char: String
	var isBuyAllowed: Bool
	var isSellAllowed: Bool
	var countryName: String
	var isAllowedInCountry: Bool
}

class BuyHostingController: UIHostingController<BuyView> {
	var contentView: BuyView

	var isLoaded: Bool = false

	init() {
		let buyViewModel = BuyViewModel()
		contentView = BuyView(viewModel: buyViewModel)

		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
