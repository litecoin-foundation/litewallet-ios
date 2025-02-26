import Foundation
import UIKit

enum PartnerName {
	case pusher
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

		return [bitrefill, moonpay]
	}

	/// Returns Partner Key
	/// - Parameter name: Enum for the different partners
	/// - Returns: Key string
	static func partnerKeyPath(name: PartnerName) -> String {
		/// Switch the config file based on the environment
		var filePath: String

		// Loads the release Partner Keys config file.
		guard let releasePath = Bundle.main.path(forResource: "partner-keys",
		                                         ofType: "plist")
		else {
			let errorDescription = "partnerkey_data_missing"
			return "error: FILE-NOT-FOUND"
		}
		filePath = releasePath

		switch name {
		case .pusher:

			if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject],
			   let key = dictionary["pusher-instance-id"] as? String
			{
				return key
			} else {
				let errorDescription = "error_pusher_id_key"
				return errorDescription
			}
		}
	}
}
