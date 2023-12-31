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
	private var emailAddress = ""

	@State
	private var isEmailValid = false

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
					Text("Don't a miss a thing!")
						.font(hugeFont)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.frame(height: buttonHeight)
						.foregroundColor(.white)
						.padding(.all, genericPad)

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

					HStack {
						VStack(alignment: .leading) {
							Text(S.Notifications.emailLabel.localize())
								.frame(height: smallLabelPad)
								.font(smallerFont)
								.multilineTextAlignment(.leading)
								.frame(maxWidth: .infinity, alignment: .leading)
								.foregroundColor(.white)

							TextField(S.Notifications.emailPlaceholder.localize(), text: $emailAddress)
								.focused($isEmailFieldFocused)
								.frame(height: buttonHeight)
								.frame(maxWidth: .infinity, alignment: .leading)
								.textFieldStyle(.roundedBorder)
								.foregroundColor(isEmailValid ? .litewalletDarkBlue : .litewalletOrange)
								.font(smallerFont)
						}
						VStack(alignment: .leading) {
							Text(S.Notifications.languagePreference.localize())
								.frame(height: smallLabelPad)
								.font(smallerFont)
								.multilineTextAlignment(.center)
								.frame(maxWidth: .infinity, alignment: .leading)
								.foregroundColor(.white)
								.offset(x: 10.0)

							Picker("", selection: $languagePref) {
								ForEach(LanguageSelection.allCases) { pref in
									Text(pref.nativeName)
										.frame(width: height * 0.3)
										.font(smallerFont)
										.foregroundColor(.white)
										.tag(pref.rawValue)
								}
							}
							.pickerStyle(.wheel)
							.frame(width: height * 0.3)
							.frame(height: buttonHeight)
							.clipped()
						}
					}
					.frame(height: 80.0)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.all, genericPad)
					Spacer()

					Button {
						viewModel.didAddToMailingList(email: emailAddress, preference: languagePref)
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
								.foregroundColor(.white)
								.shadow(radius: 3, x: 3.0, y: 3.0)

							Text(S.Button.submit.localize())
								.frame(width: width * 0.9, height: 45, alignment: .center)
								.font(buttonFont)
								.foregroundColor(isEmailValid ? .litewalletBlue :
									.litewalletBlue.opacity(0.4))
								.overlay(
									RoundedRectangle(cornerRadius: bigButtonCornerRadius)
										.stroke(.white, lineWidth: 2.0)
								)
						}
					}
					.disabled(!isEmailValid)
					.padding(.bottom, smallLabelPad)
					.onAppear {
						delay(4.0) {
							appDelegate.pushNotifications.registerForRemoteNotifications()
						}
					}
					.onChange(of: $emailAddress.wrappedValue) { _ in
						isEmailValid = EmailValidation.isEmailValid(emailString: emailAddress)
					}

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

							Text(S.Button.cancel.localize())
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
	}
}

/// Crashes when env Obj is added
// #Preview {
//	AnnounceUpdatesView(navigateStart: .create,
//	                    didTapContinue: .constant(false))
// }
