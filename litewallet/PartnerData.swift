import Foundation
import UIKit

enum PartnerName {
	case infura
	case litewalletOps
	case litewalletStart
	case pusher
	case pusherStaging
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
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])

			return "error: FILE-NOT-FOUND"
		}
		filePath = releasePath

		switch name {
		case .infura:

			if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject],
			   let key = dictionary["infura-api"] as? String
			{
				return "https://mainnet.infura.io/v3/" + key
			} else {
				let errorDescription = "infura_key_missing"
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
				return errorDescription
			}

		case .litewalletOps:
			if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject],
			   let opsArray = dictionary["litewallet-ops"] as? [String]
			{
				let randomInt = Int.random(in: 0 ..< opsArray.count)
				let key = opsArray[randomInt]
				return key
			} else {
				let errorDescription = "error_litewallet_opskey"
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
				return errorDescription
			}

		case .litewalletStart:

			if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject],
			   let key = dictionary["litewallet-start"] as? String
			{
				return key
			} else {
				let errorDescription = "error_litewallet_start_key"
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
				return errorDescription
			}

		case .pusher:

			if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject],
			   let key = dictionary["pusher-instance-id"] as? String
			{
				return key
			} else {
				let errorDescription = "error_pusher_id_key"
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
				return errorDescription
			}

		case .pusherStaging:

			if let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject],
			   let key = dictionary["pusher-staging-instance-id"] as? String
			{
				return key
			} else {
				let errorDescription = "error_pusher_id_key"
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
				return errorDescription
			}
		}
	}

	static func litewalletOpsSet() -> Set<String> {
		// Loads the Partner Keys config file.
		var setOfAddresses = Set<String>()
		guard let releasePath = Bundle.main.path(forResource: "partner-keys",
		                                         ofType: "plist")

		else {
			let errorDescription = "partnerkey_data_missing"
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])

			return [""]
		}

		if let dictionary = NSDictionary(contentsOfFile: releasePath) as? [String: AnyObject],
		   let opsArray = dictionary["litewallet-ops"] as? [String]
		{
			setOfAddresses = Set(opsArray)
		}

		return setOfAddresses
	}
}
