import SwiftUI

struct LockScreenHeaderView: View {
	// MARK: - Combine Variables

	@ObservedObject
	var viewModel: LockScreenViewModel

	@State
	private var fiatValue = ""

	@State
	private var currentFiatValue = ""

	init(viewModel: LockScreenViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		Color
			.litewalletDarkBlue
			.edgesIgnoringSafeArea(.all)
			.overlay(
				VStack {
					Spacer()
					Text(fiatValue)
						.font(Font(UIFont.barlowSemiBold(size: 16.0)))
						.foregroundColor(.white)

					Text(currentFiatValue)
						.font(Font(UIFont.barlowRegular(size: 14.0)))
						.foregroundColor(.white)
						.padding(.bottom, 10)
					Divider().background(.white)
				})
			.onAppear {
				Task {
					fiatValue = " 1 LTC = \(viewModel.currentValueInFiat)"
					currentFiatValue = "\(S.History.currentLitecoinValue.localize()) \(viewModel.currencyCode)"
				}
			}
	}
}
