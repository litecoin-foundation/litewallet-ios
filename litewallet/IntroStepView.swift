import SwiftUI

struct IntroStepView: View {
	@EnvironmentObject
	var viewModel: StartViewModel

	let paragraphFont: Font = .barlowBold(size: 35.0)

	let genericPad = 5.0

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width

			ZStack {
				CreateStepConfig
					.intro
					.backgroundColor
					.edgesIgnoringSafeArea(.all)
				VStack {
					Text(S.CreateStep.DetailedMessage.intro.localize())
						.font(paragraphFont)
						.foregroundColor(.liteWalletBlue)
						.frame(width: width * 0.9, alignment: .leading)
						.padding([.leading, .trailing], genericPad)
						.padding([.bottom], genericPad)

					Image("lofigirl")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: width * 0.9, alignment: .center)
						.mask {
							RoundedRectangle(cornerRadius: 12.0)
						}.padding()

					Text(S.CreateStep.ExtendedMessage.intro.localize())
						.font(paragraphFont)
						.foregroundColor(.liteWalletBlue)
						.frame(width: width * 0.9, alignment: .leading)
						.padding([.leading, .trailing], genericPad)
						.padding([.bottom], genericPad)
				}
				.frame(width: width * 0.9)
			}
		}
	}
}

#Preview {
	IntroStepView()
}

//                    let pushOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
//                    UNUserNotificationCenter.current().requestAuthorization(options: pushOptions) { granted, error in
//                        if granted {
//                            DispatchQueue.main.async {
//                                UIApplication.shared.registerForRemoteNotifications()
//                            }
//                        }
//                        if let error = error {
//                            print("[PushNotifications] - \(error.localizedDescription)")
//                        }
//                    }

//
// func registerPushNotification(_ application: UIApplication){
//
//    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
//
//        if granted {
//            print("Notification: Granted")
//
//        } else {
//            print("Notification: not granted")
//
//        }
//    }
//
//    application.registerForRemoteNotifications()
// }
//
// }

//                    Button(action: {
//                        //
//                        viewModel.didTapIndex = 1
//                    }) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: bigButtonCornerRadius)
//                                .frame(width: width * 0.6, height: 60, alignment: .center)
//                                .foregroundColor(.litewalletLightGray)
//                                .shadow(radius: 3, x: 3.0, y: 3.0)
//
//                            Text(S.Button.ok.localize())
//                                .frame(width: width * 0.6, height: 60, alignment: .center)
//                                .font(paragraphFont)
//                                .foregroundColor(.litewalletBlue)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: bigButtonCornerRadius)
//                                        .stroke(.white, lineWidth: 2.0)
//                                )
//                        }
//                    }
//                    .padding(.all, 8.0)

//                    viewModel.updatePushPreference(didAcceptPush: didAcceptPush)
