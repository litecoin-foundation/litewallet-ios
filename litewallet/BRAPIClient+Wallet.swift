import Foundation

private let fallbackRatesURL = "https://api-dev.lite-wallet.org/v1/rates"

extension BRAPIClient {
	func feePerKb(_ handler: @escaping (_ fees: Fees, _ error: String?) -> Void) {
		let req = URLRequest(url: url("/fee-per-kb"))
		let task = dataTaskWithRequest(req) { _, _, _ in
			let staticFees = Fees.usingDefaultValues
			handler(staticFees, nil)
		}
		task.resume()
	}

	func exchangeRates(isFallback: Bool = false, _ handler: @escaping (_ rates: [Rate], _ error: String?) -> Void) {
		let request = isFallback ? URLRequest(url: URL(string: fallbackRatesURL)!) : URLRequest(url: URL(string: APIServer.baseUrl + "v1/rates")!)
		dataTaskWithRequest(request) { data, _, error in
			if error == nil, let data = data,
			   let parsedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
			{
				if isFallback {
					guard let array = parsedData as? [Any]
					else {
						let properties = ["error_message": "is_fallback_no_rate_array_returned"]
						LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
						return handler([], "::: /rates didn't return an array")
					}
					handler(array.compactMap { Rate(data: $0) }, nil)
				} else {
					guard let array = parsedData as? [Any]
					else {
						let properties = ["error_message": "is_fallback_parsed_data_fail"]
						LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
						return handler([], "/rates didn't return an array")
					}
					handler(array.compactMap { Rate(data: $0) }, nil)
				}
			} else {
				if isFallback {
					let properties: [String: String] = ["error_message": "is_fallback_no_rate_array_returned"]
					LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
					handler([], "Error fetching from fallback url")
				} else {
					let properties: [String: String] = ["error_message": "is_fallback"]
					LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
					self.exchangeRates(isFallback: true, handler)
				}
			}
		}.resume()
	}
}
