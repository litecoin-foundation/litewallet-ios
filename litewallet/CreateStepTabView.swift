import SwiftUI

struct CreateStepTabView: View {
	@EnvironmentObject
	var createViewModel: CreateWalletViewModel

	let stepViews: [CreateStepView]

	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	init(stepViews: [CreateStepView]) {
		self.stepViews = stepViews
	}

	var body: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			let height = geometry.size.height

			VStack {
				HStack {
					Image(systemName: "triangle.inset.filled")
						.resizable()
						.foregroundColor(.white)
						.aspectRatio(contentMode: .fit)
						.frame(width: 25.0,
						       height: 25.0)
						.rotationEffect(.degrees(30))
						.onTapGesture {
							presentationMode.wrappedValue.dismiss()
						}
						.padding(.leading, 10.0)
					Spacer()
				}
				.frame(height: 30)

				Spacer()
				TabView(selection: $createViewModel.didTapIndex) {
					ForEach(0 ..< stepViews.count, id: \.self) { index in
						ZStack {
							let currentStepView = stepViews[index]
							currentStepView
								.onAppear(perform: {})
								.environmentObject(createViewModel)
						}
						.clipShape(RoundedRectangle(cornerRadius: 20.0,
						                            style: .continuous))
						.padding(.bottom, 40.0)
					}
					.padding(.all, 10)
				}
				.frame(width: UIScreen.main.bounds.width, height: height * 0.9)
				.tabViewStyle(PageTabViewStyle())
			}
		}
	}
}

#Preview {
	CreateStepTabView(stepViews: [CreateStepView(createConfig: .intro),
	                              CreateStepView(createConfig: .checkboxes)])
		.environmentObject(CreateWalletViewModel())
}
