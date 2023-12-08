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

	var store: Store
	var walletManager: WalletManager?
	var isPresentedForLock: Bool

	init(store: Store, isPresentedForLock: Bool, walletManager: WalletManager?) {
		self.store = store
		self.walletManager = walletManager
		self.isPresentedForLock = isPresentedForLock

		addSubscriptions()
		fetchCurrentPrice()
	}

	private func fetchCurrentPrice() {
		guard let currentRate = store.state.currentRate
		else {
			print("Error: Rate not fetched")
			return
		}

		// Price Label
		let fiatRate = Double(round(100 * currentRate.rate / 100))
		let formattedFiatString = String(format: "%.02f", fiatRate)
		currencyCode = currentRate.code
		let currencySymbol = Currency.getSymbolForCurrencyCode(code: currencyCode) ?? ""
		currentValueInFiat = String(currencySymbol + formattedFiatString)
	}

	// MARK: - Add Subscriptions

	private func addSubscriptions() {
		store.subscribe(self, selector: { $0.currentRate != $1.currentRate },
		                callback: { _ in
		                	self.fetchCurrentPrice()
		                })
	}
}
