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
		let bitrefill = Partner(logo: UIImage(named: "bitrefillLogo")!, headerTitle: S.BuyCenter.Cells.bitrefillTitle, details: S.BuyCenter.Cells.bitrefillFinancialDetails)
		let moonpay = Partner(logo: UIImage(named: "moonpay-logo")!, headerTitle: S.BuyCenter.Cells.moonpayTitle, details: S.BuyCenter.Cells.moonpayFinancialDetails)
		let simplex = Partner(logo: UIImage(named: "simplexLogo")!, headerTitle: S.BuyCenter.Cells.simplexTitle, details: S.BuyCenter.Cells.simplexFinancialDetails)

		return [bitrefill, moonpay, simplex]
	}
}
