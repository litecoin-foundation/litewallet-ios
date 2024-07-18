import Foundation
import SwiftUI
import UIKit

class BuyViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var receivingAddress: String = ""

	@Published
	var urlString: String = ""

	@Published
	var selectedCode: String = "USD"

	@Published
	var uuidString: String = UIDevice.current.identifierForVendor?.uuidString ?? ""

	init() {
		receivingAddress = WalletManager.sharedInstance.wallet?.receiveAddress ?? ""
	}

	func fetchCurrenciesCountries(completion: @escaping ([MoonpayCountryData]) -> Void) {
		let url = URL(string: "https://api.moonpay.com/v3/countries")!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 10
		request.allHTTPHeaderFields = ["accept": "application/json"]

		let task = URLSession.shared.dataTask(with: request) { data, _, error in

			if error == nil {
				DispatchQueue.main.sync {
					if let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []),
					   let jsonArray = jsonData as? [[String: Any]]
					{
						var dataArray: [MoonpayCountryData] = []

						/// Filters allowed currencies and the top ranked currencies
						for element in jsonArray {
							if element["isBuyAllowed"] as? Bool == true &&
								element["isAllowed"] as? Bool == true
							{
								let alpha2 = element["alpha2"] as? String
								let alpha3 = element["alpha3"] as? String
								let name = element["name"] as? String
								let isBuyAllowed = element["isBuyAllowed"] as? Bool
								let isSellAllowed = element["isSellAllowed"] as? Bool
								let isAllowed = element["isAllowed"] as? Bool

								let mpCountryData = MoonpayCountryData(alphaCode2Char: alpha2 ?? "",
								                                       alphaCode3Char: alpha3 ?? "",
								                                       isBuyAllowed: isBuyAllowed ?? false,
								                                       isSellAllowed: isSellAllowed ?? false,
								                                       countryName: name ?? "",
								                                       isAllowedInCountry: isAllowed ?? false)

								dataArray.append(mpCountryData)
							}
						}
						completion(dataArray)
					}
				}
			} else {
				let currencyError: [String: String] = ["error": error?.localizedDescription ?? ""]
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: currencyError)
				completion([])
			}
		}
		task.resume()
	}
}
