import SwiftUI

struct StartView: View {
	let buttonFont: Font = .barlowSemiBold(size: 20.0)
	let buttonLightFont: Font = .barlowLight(size: 20.0)

	var body: some View {
		GeometryReader { geometry in

			let height = geometry.size.height
			let width = geometry.size.width

			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)

				Group {
//					VStack {
//						Image("new-logotype-white")
//							.resizable()
//							.aspectRatio(contentMode: .fit)
//							.frame(width: width * 0.7)
//
//						Text(S.StartViewController.createButton.localize())
//							.frame(width: width * 0.9, height: 45, alignment: .center)
//							.font(buttonFont)
//							.foregroundColor(.litewalletBlue)
//							.overlay(
//								RoundedRectangle(cornerRadius: bigButtonCornerRadius)
//									.stroke(.white)
//							)
//					}.frame(height: height * 0.1)
//						.background(Color.green)

					VStack {
						Spacer()
						Button(action: {}) {
							HStack {
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
												.stroke(.white)
										)
								}
							}
						}
						.padding(.all, swiftUICellPadding)

						Button(action: {}) {
							HStack {
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
						}
						.padding(.all, swiftUICellPadding)
					}
					.frame(height: height * 0.9)
				}
			}
		}
	}
}

#Preview {
	StartView()
}
