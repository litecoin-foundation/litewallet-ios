import SwiftUI

struct LoginCardAlertView<Presenting>: View where Presenting: View {
	@Binding
	var isShowingLoginAlert: Bool

	@Binding
	var didFail: Bool

	@Binding
	var mainMessage: String

	let presenting: Presenting

	var body: some View {
		GeometryReader { (deviceSize: GeometryProxy) in
			HStack { Spacer()
				ZStack {
					self.presenting.disabled(isShowingLoginAlert)

					VStack {
						Text(self.mainMessage)
							.padding()
							.font(Font(UIFont.customMedium(size: 16.0)))
							.foregroundColor(Color(UIColor.liteWalletBlue))
						ActivityIndicator(isAnimating: $isShowingLoginAlert,
						                  style: .medium)
							.padding(.bottom, 15)
						Divider()
						HStack {
							Button(action: {
								withAnimation {
									self.isShowingLoginAlert.toggle()
								}
							}) {
								Text(S.Prompts.dismiss.localizedCapitalized)
									.font(Font(UIFont.barlowLight(size: 14.0)))
									.foregroundColor(.gray)
							}.padding([.top, .bottom], 5)
						}
					}
					.padding()
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color.gray, lineWidth: 1.5)
					)
					.background(Color.white)
					.cornerRadius(8)
					.frame(
						width: deviceSize.size.width * 0.85,
						height: deviceSize.size.height * 0.5
					)
					.shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 5, y: 5)
					.opacity(self.isShowingLoginAlert ? 1 : 0)
				}
				Spacer()
			}
		}
	}
}

struct LoginCardAlertView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			Text("").padding(.all, 10)
				.loginAlertView(isShowingLoginAlert: .constant(true),
				                didFail: .constant(true),
				                message: .constant("Login..."))
			Spacer()
		}
	}
}
