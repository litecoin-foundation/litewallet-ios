import SwiftUI

struct IntroStepView: View {
	@ObservedObject
	var createViewModel: CreateWalletViewModel

	let paragraphFont: Font = .barlowSemiBold(size: 22.0)

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			ZStack {
				CreateStepConfig
					.intro
					.backgroundColor
					.edgesIgnoringSafeArea(.all)
				VStack {
					Text(S.CreateStep.MainTitle.intro.localize())
						.font(.barlowBold(size: 24.0))
						.foregroundColor(.litewalletDarkBlue)
						.padding([.bottom, .top], 20.0)

					Text(S.CreateStep.DetailedMessage.intro.localize())
						.font(paragraphFont)
						.foregroundColor(.litewalletDarkBlue)
						.frame(width: width * 0.8, alignment: .leading)
						.padding([.leading, .trailing], 20.0)
						.padding(.bottom, 20.0)

					Text(S.CreateStep.ExtendedMessage.intro.localize())
						.font(paragraphFont)
						.foregroundColor(.litewalletDarkBlue)
						.frame(width: width * 0.8, alignment: .leading)
						.padding([.leading, .trailing], 20.0)
						.padding(.bottom, 20.0)

					Text(S.CreateStep.Bullet1.intro.localize())
						.font(paragraphFont)
						.foregroundColor(.litewalletDarkBlue)
						.frame(width: width * 0.8, alignment: .leading)
						.padding([.leading, .trailing], 20.0)
						.padding(.bottom, 20.0)
					Spacer()

					Button(action: {
						//
						createViewModel.didTapIndex = 1
					}) {
						ZStack {
							RoundedRectangle(cornerRadius: bigButtonCornerRadius)
								.frame(width: width * 0.6, height: 60, alignment: .center)
								.foregroundColor(.litewalletLightGray)
								.shadow(radius: 3, x: 3.0, y: 3.0)

							Text(S.Button.ok.localize())
								.frame(width: width * 0.6, height: 60, alignment: .center)
								.font(paragraphFont)
								.foregroundColor(.litewalletBlue)
								.overlay(
									RoundedRectangle(cornerRadius: bigButtonCornerRadius)
										.stroke(.white, lineWidth: 2.0)
								)
						}
					}
					.padding(.all, 8.0)
					Spacer()
				}
				.frame(width: width * 0.9)
			}
		}
	}
}

#Preview {
	IntroStepView(createViewModel: CreateWalletViewModel())
}
