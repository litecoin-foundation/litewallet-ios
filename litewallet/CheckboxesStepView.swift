import SafariServices
import SwiftUI

struct CheckboxesStepView: View {
	@EnvironmentObject
	var viewModel: StartViewModel

	let paragraphFont: Font = .barlowSemiBold(size: 22.0)
	let calloutFont: Font = .barlowLight(size: 12.0)

	let genericPad = 5.0

	@State private var scroll = false

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
					WebView(url: URL(string: C.signupURL)!,
					        scrollToSignup: $scroll)
						.frame(width: width * 0.9)
						.padding([.leading, .trailing], genericPad)
						.edgesIgnoringSafeArea(.all)
						.onAppear {
							delay(2.0) {
								scroll = true
							}
						}.mask(
							RoundedRectangle(cornerRadius: 12.0)
								.frame(width: width * 0.9,
								       height: height * 0.9)
						)
				}
				.frame(width: width * 0.9)
			}
		}
	}
}

#Preview {
	CheckboxesStepView()
}
