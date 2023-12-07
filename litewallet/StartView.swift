import SwiftUI
import UIKit

struct StartView: View {
	let buttonFont: Font = .barlowSemiBold(size: 20.0)
	let buttonLightFont: Font = .barlowLight(size: 20.0)
	let tinyFont: Font = .barlowRegular(size: 12.0)

	let squareButtonSize: CGFloat = 55.0
	let squareImageSize: CGFloat = 25.0

	@ObservedObject
	var startCardViewModel = StartCardViewModel()

	@ObservedObject
	var createViewModel = CreateWalletViewModel()

	@ObservedObject
	var recoverViewModel = RecoverWalletViewModel()

	@State
	private var selectedLang: Bool = false

	@State
	private var delayedSelect: Bool = false

	@State
	private var currentTagline = ""

	@State
	private var currentLanguage: LanguageSelection = .English

	init() {}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			NavigationView {
				ZStack {
					Color.litewalletBlue.edgesIgnoringSafeArea(.all)
					VStack {
						Spacer()
						Image("new-logotype-white")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: width * 0.6)
							.padding(.top, height * 0.05)
							.padding(.bottom, height * 0.05)

						Text(currentTagline)
							.font(buttonLightFont)
							.multilineTextAlignment(.center)
							.fixedSize(horizontal: false,
							           vertical: true)
							.foregroundColor(.white)
							.frame(width: width * 0.7,
							       height: height * 0.05,
							       alignment: .center)
							.padding(.top, height * 0.02)
							.padding(.bottom, height * 0.08)
							.animation(.bouncy)
							.onAppear {
								currentTagline = startCardViewModel.staticTagline
							}
						HStack {
							ZStack {
								Text(startCardViewModel.currentLanguage.nativeName)
									.font(selectedLang ? buttonFont : buttonLightFont)
									.transition(.scale)
									.foregroundColor(.white)
									.multilineTextAlignment(.center)

								Image(systemName: "checkmark.message.fill")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: squareImageSize,
									       height: squareImageSize,
									       alignment: .center)
									.foregroundColor(startCardViewModel
										.didSelectLanguage ?
										.litewalletGreen : .litecoinGray.opacity(0.4))
									.shadow(radius: 6, x: 3.0, y: 3.0)
									.padding(.all, 4.0)
									.frame(width: width * 0.3,
									       height: squareButtonSize,
									       alignment: .center)
									.offset(CGSize(width: width * 0.18,
									               height: -height * 0.03))
							}
						}
						.frame(width: width * 0.9,
						       height: height * 0.1,
						       alignment: .center)
						.onTapGesture {
							startCardViewModel
								.didSelectLanguage
								.toggle()
							if startCardViewModel
								.didSelectLanguage
							{
								currentTagline = startCardViewModel
									.taglines[startCardViewModel.currentLanguage.rawValue]
								startCardViewModel
									.speakLanguage(currentLanguage:
										startCardViewModel.currentLanguage)
								delay(1.5) {
									delayedSelect = true
								}
							} else {
								startCardViewModel.startTimer()
								currentTagline = startCardViewModel.staticTagline
							}
						}
						.alert(startCardViewModel
							.alertMessage[startCardViewModel.currentLanguage.rawValue],
							isPresented: $delayedSelect) {
								HStack {
									Button(S.Button.yes.localize(), role: .cancel) {
										startCardViewModel.setLanguage(code: startCardViewModel.currentLanguage.code)
									}
									Button(S.Button.cancel.localize(), role: .destructive) {
										// Dismisses
									}
								}
						}
						Spacer()
						NavigationLink(destination:
							CreateWalletView(viewModel: createViewModel)

						) {
							ZStack {
								RoundedRectangle(cornerRadius: bigButtonCornerRadius)
									.frame(width: width * 0.9, height: 45, alignment: .center)
									.foregroundColor(.white)
									.shadow(radius: 3, x: 3.0, y: 3.0)

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
									.foregroundColor(Color(UIColor.liteWalletBlue)
									).shadow(radius: 5, x: 3.0, y: 3.0)

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
							.padding(.all, 5.0)
					}
					.padding(.all, swiftUICellPadding)
				}
			}
		}
	}
}

#Preview {
	StartView()
		.environment(\.locale, .init(identifier: "en"))
		.environmentObject(StartCardViewModel())
}
