import Foundation
import UIKit

enum PartnerName {
	case unstop
	case changeNow
}

struct Partner {
	let logo: UIImage
	let headerTitle: String
	let details: String

	/// Fills partner data
	/// - Returns: Array of Partner Data
	static func partnerDataArray() -> [Partner] {
		let bitrefill = Partner(logo: UIImage(named: "bitrefillLogo")!, headerTitle: S.BuyCenter.Cells.bitrefillTitle.localize(), details: S.BuyCenter.Cells.bitrefillFinancialDetails.localize())
		let moonpay = Partner(logo: UIImage(named: "moonpay-logo")!, headerTitle: S.BuyCenter.Cells.moonpayTitle.localize(), details: S.BuyCenter.Cells.moonpayFinancialDetails.localize())
		let simplex = Partner(logo: UIImage(named: "simplexLogo")!, headerTitle: S.BuyCenter.Cells.simplexTitle.localize(), details: S.BuyCenter.Cells.simplexFinancialDetails.localize())

		return [bitrefill, moonpay, simplex]
	}
}
