import SwiftUI

struct CheckboxesStepView: View {
	@ObservedObject
	var createViewModel: CreateWalletViewModel

	let paragraphFont: Font = .barlowSemiBold(size: 22.0)

	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	@State
	private var didAcceptPush: Bool = false
	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height

			ZStack {
				CreateStepConfig
					.checkboxes
					.backgroundColor
					.edgesIgnoringSafeArea(.all)
				VStack {
					Text(S.CreateStep.MainTitle.checkboxes.localize())
						.font(.barlowBold(size: 24.0))
						.foregroundColor(.litewalletDarkBlue)
						.padding([.bottom, .top], 20.0)
					HStack {
						Text(S.CreateStep.DetailedMessage.checkboxes.localize())
							.font(paragraphFont)
							.foregroundColor(.litewalletDarkBlue)
							.frame(width: width * 0.6, alignment: .leading)
							.padding([.leading, .trailing], 20.0)

						Spacer()
                        
						Image(systemName: didAcceptPush ? "checkmark.circle.fill" : "checkmark.circle")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 30, height: 30, alignment: .leading)
							.foregroundColor(didAcceptPush ? .litewalletGreen : .litecoinSilver)
							.padding()
					}
					.onTapGesture {
						didAcceptPush.toggle()
						if didAcceptPush {
							appDelegate.pushNotifications.registerForRemoteNotifications()
						}
					}
					.padding(.bottom, 20.0)

					Text(S.CreateStep.ExtendedMessage.checkboxes.localize())
						.font(paragraphFont)
						.foregroundColor(.litewalletDarkBlue)
						.frame(width: width * 0.8, alignment: .leading)
						.padding([.leading, .trailing], 20.0)
						.padding(.bottom, 20.0)

					Text(S.CreateStep.Bullet1.checkboxes.localize())
						.font(paragraphFont)
						.foregroundColor(.litewalletDarkBlue)
						.frame(width: width * 0.8, alignment: .leading)
						.padding([.leading, .trailing], 20.0)
						.padding(.bottom, 20.0)
					Spacer()
				}
				.frame(width: width * 0.9)
			}
		}
	}
}

#Preview {
	CheckboxesStepView(createViewModel: CreateWalletViewModel())
}
