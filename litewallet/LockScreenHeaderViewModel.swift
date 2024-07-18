import AVFoundation
import Foundation
import SwiftUI
import UIKit

class LockScreenViewModel: ObservableObject, Subscriber {
	// MARK: - Combine Variables

	@Published
	var currentValueInFiat: String = ""

	@Published
	var currencyCode: String = ""

	// MARK: - Public Variables

	var store: Store?

	init(store: Store) {
		self.store = store
		addSubscriptions()
		fetchCurrentPrice()
	}

	private func fetchCurrentPrice() {
		guard let currentRate = store?.state.currentRate
		else {
			let properties = ["error_message": "rate_not_fetched"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
			return
		}

		// Price Label
		let formattedRate = String(format: "%.02f", currentRate.rate)
		currencyCode = currentRate.code

		if let symbol = Rate.symbolMap[currencyCode] {
			currentValueInFiat = String(symbol + formattedRate)
		} else {
			let properties = ["error_message": "fiat_symbol_not_found",
			                  "missing_code": "\(currencyCode)"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: properties)
			currentValueInFiat = String("" + formattedRate)
		}
	}

	// MARK: - Add Subscriptions

	private func addSubscriptions() {
		guard let store = store
		else {
			let errorDescription = "store_not_initialized"
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
			return
		}

		store.subscribe(self, selector: { $0.currentRate != $1.currentRate },
		                callback: { _ in
		                	self.fetchCurrentPrice()
		                })
	}
}
