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
	private var scroll = false

	@State
	private var shouldEnableButton = false

	@Binding
	var didTapContinue: Bool

	let navigateStart: NavigateStart

	let paragraphFont: Font = .barlowSemiBold(size: 22.0)
	let calloutFont: Font = .barlowLight(size: 12.0)

	let genericPad = 5.0
	let hugeFont = Font.barlowBold(size: 30.0)
	let smallerFont = Font.barlowLight(size: 15.0)
	let buttonLightFont: Font = .barlowLight(size: 20.0)
	let buttonFont: Font = .barlowSemiBold(size: 20.0)
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

	init(navigateStart: NavigateStart, didTapContinue: Binding<Bool>) {
		self.navigateStart = navigateStart
		_didTapContinue = didTapContinue
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			ZStack {
				Color.liteWalletDarkBlue.edgesIgnoringSafeArea(.all)
				VStack {
					Text("Make sure not to miss anything!")
						.font(hugeFont)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding([.leading, .trailing, .bottom], 10.0)
						.foregroundColor(.white)
						.padding(.all, 10.0)

					WebView(url: URL(string: C.signupURL)!,
					        scrollToSignup: $scroll)
						.frame(width: width * 0.9)
						.frame(height: 100)
						.edgesIgnoringSafeArea(.all)
						.onAppear {
							delay(2.0) {
								scroll = true
							}
						}

					Text("Entering your email is a great idea because you will hear about updates and contests. Please consider signing up to also for push notifications.")
						.font(smallerFont)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding([.leading, .trailing, .bottom], 10.0)
						.foregroundColor(.white)
						.padding(.all, 10.0)

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
								.foregroundColor(.white)
								.shadow(radius: 3, x: 3.0, y: 3.0)

							Text(S.StartViewController.continueButton.localize())
								.frame(width: width * 0.9, height: 45, alignment: .center)
								.font(buttonFont)
								.foregroundColor(shouldEnableButton ? .litewalletBlue :
									.litewalletBlue.opacity(0.4))
								.overlay(
									RoundedRectangle(cornerRadius: bigButtonCornerRadius)
										.stroke(.white, lineWidth: 2.0)
								)
						}
					}
					.disabled(shouldEnableButton)
					.padding(.all, 10.0)
					.onAppear {
						delay(4.0) {
							appDelegate.pushNotifications.registerForRemoteNotifications()
						}
					}
				}
			}
		}
	}
}

// #Preview {
//	///	AnnounceUpdatesView()
// }
