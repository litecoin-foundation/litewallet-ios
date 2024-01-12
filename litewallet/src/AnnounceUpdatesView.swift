import PushNotifications
import SafariServices
import SwiftUI

enum NavigateStart {
	case create
	case recover
}

struct AnnounceUpdatesView: View {
	@EnvironmentObject
	var viewModel: StartViewModel

	@State
	private var didComplete = false

	@State
	private var languagePref: LanguageSelection = .English

	@FocusState private var isEmailFieldFocused: Bool

	@Binding
	var didTapContinue: Bool

	let navigateStart: NavigateStart

	let paragraphFont: Font = .barlowSemiBold(size: 22.0)
	let calloutFont: Font = .barlowLight(size: 12.0)

	let genericPad = 20.0
	let smallLabelPad = 15.0
	let buttonHeight = 44.0
	let pageHeight = 145.0
	let hugeFont = Font.barlowBold(size: 30.0)
	let smallerFont = Font.barlowLight(size: 15.0)
	let buttonLightFont: Font = .barlowLight(size: 20.0)
	let buttonFont: Font = .barlowSemiBold(size: 20.0)
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

	init(navigateStart: NavigateStart, language: LanguageSelection, didTapContinue: Binding<Bool>) {
		self.navigateStart = navigateStart
		languagePref = language
		_didTapContinue = didTapContinue
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			ZStack {
				Color.liteWalletDarkBlue.edgesIgnoringSafeArea(.all)
				VStack {
					Text(S.Notifications.emailTitle.localize())
						.font(hugeFont)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.frame(idealHeight: buttonHeight)
						.foregroundColor(.white)
						.padding(.all, genericPad)
						.padding(.top, height * 0.08)

					Text(S.Notifications.pitchMessage.localize())
						.font(buttonLightFont)
						.kerning(0.3)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(.white)
						.padding(.all, genericPad)
						.onTapGesture {
							isEmailFieldFocused.toggle()
						}

					SignupWebView(userAction: $didComplete,
					              urlString: C.signupURL)
						.frame(width: width)
						.frame(height: pageHeight)
						.edgesIgnoringSafeArea(.all)
						.padding(.bottom, smallLabelPad)
						.onChange(of: didComplete) { updateValue in
							if updateValue {
								switch navigateStart {
								case .create:
									viewModel.didTapCreate!()
								case .recover:
									viewModel.didTapRecover!()
								}
							}
						}

					Spacer()
					Button {
						/// Reuse this struct for  Create or Recover
						switch navigateStart {
						case .create:
							viewModel.didTapCreate!()
						case .recover:
							viewModel.didTapRecover!()
						}

					} label: {
						ZStack {
							RoundedRectangle(cornerRadius: bigButtonCornerRadius)
								.frame(width: width * 0.9, height: 45, alignment: .center)
								.foregroundColor(.litewalletDarkBlue)

							Text(S.Notifications.signupCancel.localize())
								.frame(width: width * 0.9, height: 45, alignment: .center)
								.font(buttonLightFont)
								.foregroundColor(.white)
								.overlay(
									RoundedRectangle(cornerRadius: bigButtonCornerRadius)
										.stroke(.white, lineWidth: 0.5)
								)
						}
					}
					.padding(.bottom, genericPad)
				}
			}
		}
		.edgesIgnoringSafeArea(.top)
	}
}

/// Crashes when env Obj is added
// #Preview {
//	AnnounceUpdatesView(navigateStart: .create,
//	                    didTapContinue: .constant(false))
// }
