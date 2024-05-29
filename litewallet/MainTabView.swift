import SwiftUI

struct MainTabView: View {
	@ObservedObject
	var viewModel: MainTabViewModel

	@State
	private var doesHaveAccessToServices = false

	@State
	private var tabAnimationValue = 1.0

	init(viewModel: MainTabViewModel) {
		self.viewModel = viewModel
		viewModel.checkServicesAvailability()
	}

	var body: some View {
		GeometryReader { _ in

//			let width = geometry.size.width
//			let height = geometry.size.height

			ZStack {
				Color.liteWalletBlue.edgesIgnoringSafeArea(.all)
				TabView {
					HistoryTabView(store: viewModel.store, walletManager: viewModel.walletManager)
						.tabItem {
							VStack {
								Text(S.History.barItemTitle.localize())
								Image("history_icon")
									.renderingMode(.template)
							}
						}

					SendTabView(store: viewModel.store)
						.tabItem {
							VStack {
								Text(S.Send.barItemTitle.localize())
								Image("send_icon")
									.renderingMode(.template)
							}
						}

					ReceiveTabView()
						.tabItem {
							VStack {
								Text(S.Receive.barItemTitle.localize())
								Image("receive_icon")
									.renderingMode(.template)
							}
						}
					if doesHaveAccessToServices {
						BuyTabView()
							.tabItem {
								VStack {
									Text(S.BuyCenter.barItemTitle.localize())
									Image("litecoin_cutout24")
										.renderingMode(.template)
								}
								.animation(.easeInOut(duration: 1.2),
								           value: tabAnimationValue)
							}
					}
				}
				.accentColor(.liteWalletBlue)
				.foregroundColor(Color.litecoinSilver)
				.onReceive(viewModel.$doesHaveAccessToServices) { currentAccessToServices in
					doesHaveAccessToServices = currentAccessToServices
				}
			}
		}
	}
}

// #Preview {
//	MainTabView(viewModel: MainTabViewModel(store: Store(), walletManager: WalletManager(store: Store())))
// }
