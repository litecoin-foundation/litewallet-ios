import SwiftUI

struct HistoryTabView: View {
	private var store: Store

	private var walletManager: WalletManager

	@State
	private var isLtcSwapped: Bool = false

	// private var transactionsViewController: TransactionsViewController

	init(store: Store, walletManager: WalletManager) {
		self.store = store
		self.walletManager = walletManager
		isLtcSwapped = self.store.state.isLtcSwapped
//
//		transactionsViewController = TransactionsViewController()
//		transactionsViewController.store = self.store
//		transactionsViewController.walletManager = self.walletManager
//		transactionsViewController.isLtcSwapped = isLtcSwapped
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			ZStack {
				Color.white.edgesIgnoringSafeArea(.all)
				// transactionsViewController
			}
		}
	}
}

//
// #Preview {
//	HistoryTabView()
// }
