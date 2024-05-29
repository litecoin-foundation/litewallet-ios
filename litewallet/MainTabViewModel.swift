import Foundation
import SwiftUI
import UIKit

class MainTabViewModel: ObservableObject, Subscriber {
	// MARK: - Combine Variables

	var store: Store
	var walletManager: WalletManager

	@Published
	var doesHaveAccessToServices = false

	init(store: Store, walletManager: WalletManager) {
		self.store = store
		self.walletManager = walletManager

		self.store.subscribe(self,
		                     selector: { $0.walletState.syncProgress != $1.walletState.syncProgress },
		                     callback: { _ in
		                     	self.checkServicesAvailability()
		                     })

		self.store.subscribe(self,
		                     selector: { $0.walletState.isConnected != $1.walletState.isConnected },
		                     callback: { _ in
		                     	self.checkServicesAvailability()
		                     })
	}

	func checkServicesAvailability() {
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

						/// Set default to no access
						self.doesHaveAccessToServices = false

						let currentLocaleCode = Locale.current.regionCode ?? "RU"

						/// Allowed in Country
						for country in dataArray {
							if country.alphaCode2Char == currentLocaleCode {
								delay(2.0) {
									self.doesHaveAccessToServices = true
								}
							}
						}

						/// Wrote down paper key
						if let writeDate = UserDefaults.writePaperPhraseDate,
						   writeDate.addingTimeInterval(-2000) > Date()
						{
							delay(2.0) {
								self.doesHaveAccessToServices = true
							}
						}

						/// Has Launched
						if let launchNumber = UserDefaults.standard.object(forKey: numberOfLitewalletLaunches) as? Int,
						   launchNumber > 2
						{
							delay(2.0) {
								self.doesHaveAccessToServices = true
							}
						}

						self.doesHaveAccessToServices = false
					}
				}
			}
		}
		task.resume()
	}
}

//
//
// let task = URLSession.shared.dataTask(with: request) { data, _, error in
//
//    if error == nil {
//        DispatchQueue.main.sync {
//            if let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []),
//               let jsonArray = jsonData as? [[String: Any]]
//            {
//                var dataArray: [MoonpayCountryData] = []
//
//                /// Filters allowed currencies and the top ranked currencies
//                for element in jsonArray {
//                    if element["isBuyAllowed"] as? Bool == true &&
//                        element["isAllowed"] as? Bool == true
//                    {
//                        let alpha2 = element["alpha2"] as? String
//                        let alpha3 = element["alpha3"] as? String
//                        let name = element["name"] as? String
//                        let isBuyAllowed = element["isBuyAllowed"] as? Bool
//                        let isSellAllowed = element["isSellAllowed"] as? Bool
//                        let isAllowed = element["isAllowed"] as? Bool
//
//                        let mpCountryData = MoonpayCountryData(alphaCode2Char: alpha2 ?? "",
//                                                               alphaCode3Char: alpha3 ?? "",
//                                                               isBuyAllowed: isBuyAllowed ?? false,
//                                                               isSellAllowed: isSellAllowed ?? false,
//                                                               countryName: name ?? "",
//                                                               isAllowedInCountry: isAllowed ?? false)
//
//                        dataArray.append(mpCountryData)
//                    }
//                }
//                completion(dataArray)
//            }
//        }
//    } else {
//        let currencyError: [String: String] = ["error": error?.localizedDescription ?? ""]
//        LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: currencyError)
//        completion([])
//    }
// }
// task.resume()
