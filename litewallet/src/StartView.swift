import SwiftUI
import UIKit

struct StartView: View {
	let buttonFont: Font = .barlowSemiBold(size: 20.0)
	let buttonLightFont: Font = .barlowLight(size: 20.0)
	let tinyFont: Font = .barlowRegular(size: 12.0)

	let squareButtonSize: CGFloat = 55.0
	let squareImageSize: CGFloat = 25.0

	@ObservedObject
	var startViewModel: StartViewModel

	@State
	private var selectedLang: Bool = false

	@State
	private var delayedSelect: Bool = false

	@State
	private var currentTagline = ""

	@State
	private var animationAmount = 0.0

	@State
	private var pickedLanguage: LanguageSelection = .English

	@State
	private var didContinue: Bool = false

	init(viewModel: StartViewModel) {
		startViewModel = viewModel
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			NavigationView {
				ZStack {
					Color.litewalletDarkBlue.edgesIgnoringSafeArea(.all)
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
							.onAppear {
								currentTagline = startViewModel.staticTagline
							}
						HStack {
							ZStack {
								Picker("", selection: $pickedLanguage) {
									ForEach(startViewModel.languages, id: \.self) {
										Text($0.nativeName)
											.font(selectedLang ? buttonFont : buttonLightFont)
											.foregroundColor(.white)
									}
								}
								.pickerStyle(.wheel)
								.frame(width: width * 0.5)
								.onChange(of: $pickedLanguage.wrappedValue) { _ in
									startViewModel.currentLanguage = pickedLanguage
									selectedLang = true
									currentTagline = startViewModel.taglines[startViewModel.currentLanguage.rawValue]
									startViewModel.speakLanguage()
									delay(1.5) {
										delayedSelect = true
									}
								}

								Image(systemName: "checkmark.message.fill")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: squareImageSize,
									       height: squareImageSize,
									       alignment: .center)
									.foregroundColor(selectedLang ?
										.litewalletGreen : .litecoinGray.opacity(0.4))
									.shadow(radius: 6, x: 3.0, y: 3.0)
									.padding(.all, 4.0)
									.frame(width: width * 0.3,
									       height: squareButtonSize,
									       alignment: .center)
									.offset(CGSize(width: width * 0.18,
									               height: -height * 0.03))
									.scaleEffect(CGSize(width: animationAmount, height: animationAmount))
									.animation(
										.easeInOut(duration: 1.8)
											.repeatCount(5),
										value: animationAmount
									)
									.onAppear {
										animationAmount = 1.0
									}
							}
						}
						.frame(width: width * 0.9,
						       height: height * 0.1,
						       alignment: .center)
						.alert(startViewModel
							.alertMessage[startViewModel.currentLanguage.rawValue],
							isPresented: $delayedSelect)
						{
							HStack {
								Button(S.Button.yes.localize(), role: .cancel) {
									startViewModel.setLanguage(code: startViewModel.currentLanguage.code)
									selectedLang = false
								}
								Button(S.Button.cancel.localize(), role: .destructive) {
									// Dismisses
									selectedLang = false
								}
							}
						}
						Spacer()
						NavigationLink(destination:

							AnnounceUpdatesView(navigateStart: .create,
							                    language: startViewModel.currentLanguage,
							                    didTapContinue: $didContinue)
								.environmentObject(startViewModel)
								.navigationBarBackButtonHidden(true)
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

							AnnounceUpdatesView(navigateStart: .recover,
							                    language: startViewModel.currentLanguage,
							                    didTapContinue: $didContinue)
								.environmentObject(startViewModel)
								.navigationBarBackButtonHidden(true)
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
		.alert(S.LitewalletAlert.error.localize(),
		       isPresented: $startViewModel.walletCreationDidFail,
		       actions: {
		       	HStack {
		       		Button(S.Button.ok.localize(), role: .cancel) {
		       			startViewModel.walletCreationDidFail = false
		       		}
		       	}
		       })
	}
}

// #Preview {
//	StartView(viewModel: StartViewModel(store: Store(),
//	                                    walletManager: WalletManager(store: Store())))
//		.environment(\.locale, .init(identifier: "en"))
// }
