import Foundation
import SwiftUI
import UIKit

class MainTabViewController: UIHostingController<MainTabView> {
	var contentView: MainTabView
	var store: Store
	var walletManager: WalletManager

	init(store: Store, walletManager: WalletManager) {
		self.store = store
		self.walletManager = walletManager
		let mainTabViewModel = MainTabViewModel(store: store, walletManager: walletManager)
		contentView = MainTabView(viewModel: mainTabViewModel)
		super.init(rootView: contentView)
	}

	@available(*, unavailable)
	@MainActor dynamic required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//        buyViewModel.fetchCurrenciesCountries { fetchedData in
//            for country in fetchedData {
//                print("::: Name: \(country.countryName) isAllowed: \(country.isBuyAllowed)")
//            }
//        }
