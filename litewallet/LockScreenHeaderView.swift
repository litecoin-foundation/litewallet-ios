import SwiftUI

struct LockScreenHeaderView: View {
	// MARK: - Combine Variables

	@ObservedObject
	var viewModel: LockScreenViewModel

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
					Text(" 1 LTC = \(viewModel.currentValueInFiat)")
						.font(Font(UIFont.barlowSemiBold(size: 16.0)))
						.foregroundColor(.white)

					Text("\(S.History.currentLitecoinValue.localize()) \(viewModel.currencyCode)")
						.font(Font(UIFont.barlowRegular(size: 14.0)))
						.foregroundColor(.white)
						.padding(.bottom, 10)
					Divider().background(.white)
				})
	}
}
