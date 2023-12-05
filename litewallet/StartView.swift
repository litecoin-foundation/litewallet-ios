import SwiftUI
import UIKit

struct StartView: View {
	let buttonFont: Font = .barlowSemiBold(size: 20.0)
	let buttonLightFont: Font = .barlowLight(size: 20.0)
	let tinyFont: Font = .barlowRegular(size: 12.0)

	@ObservedObject
	var createViewModel = CreateWalletViewModel()

	@ObservedObject
	var recoverViewModel = RecoverWalletViewModel()

	init() {}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width

			NavigationView {
				ZStack {
					Color.litewalletBlue.edgesIgnoringSafeArea(.all)
					VStack {
						Spacer()
						Image("new-logotype-white")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: width * 0.6)

						Text(S.StartViewController.tagline.localize())
							.font(buttonLightFont)
							.multilineTextAlignment(.center)
							.lineLimit(3)
							.foregroundColor(.white)
							.frame(width: width * 0.9, alignment: .center)
							.padding(.top, 30.0)
						Spacer()
					}
					VStack {
						Spacer()
						NavigationLink(destination:
							CreateWalletView(viewModel: createViewModel)

						) {
							ZStack {
								RoundedRectangle(cornerRadius: bigButtonCornerRadius)
									.frame(width: width * 0.9, height: 45, alignment: .center)
									.foregroundColor(.white)

								Text(S.StartViewController.createButton.localize())
									.frame(width: width * 0.9, height: 45, alignment: .center)
									.font(buttonFont)
									.foregroundColor(.litewalletBlue)
									.overlay(
										RoundedRectangle(cornerRadius: bigButtonCornerRadius)
											.stroke(.white, lineWidth: 2.0)
									)
							}
						}
						.padding([.top, .bottom], 10.0)

						NavigationLink(destination:
							RecoverWalletView(viewModel: recoverViewModel)
						) {
							ZStack {
								RoundedRectangle(cornerRadius: bigButtonCornerRadius)
									.frame(width: width * 0.9, height: 45, alignment: .center)
									.foregroundColor(Color(UIColor.liteWalletBlue))

								Text(S.StartViewController.recoverButton.localize())
									.frame(width: width * 0.9, height: 45, alignment: .center)
									.font(buttonLightFont)
									.foregroundColor(Color(UIColor.litecoinWhite))
									.overlay(
										RoundedRectangle(cornerRadius: bigButtonCornerRadius)
											.stroke(.white)
									)
							}
						}
						.padding([.top, .bottom], 10.0)

						Text(AppVersion.string)
							.frame(width: 100, alignment: .center)
							.font(tinyFont)
							.foregroundColor(.white)
							.padding(.all, 10.0)
					}
					.padding(.all, swiftUICellPadding)
				}
			}
		}
	}
}

#Preview {
	StartView()
}
