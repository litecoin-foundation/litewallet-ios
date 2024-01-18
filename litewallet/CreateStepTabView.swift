import SwiftUI

struct CreateStepTabView: View {
	@EnvironmentObject
	var viewModel: StartViewModel

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
				ZStack {
					HStack {
						Image(systemName: "chevron.left")
							.resizable()
							.foregroundColor(.white)
							.aspectRatio(contentMode: .fit)
							.frame(width: 25.0,
							       height: 25.0)
							.onTapGesture {
								presentationMode
									.wrappedValue
									.dismiss()
								viewModel.tappedIndex = 0
							}
							.padding(.leading, 10.0)
						Spacer()
					}

					HStack {
						Text(viewModel.headerTitle)
							.font(.barlowBold(size: 30.0))
							.foregroundColor(.litecoinGray)
							.padding([.bottom, .top], 10.00)
					}
					.frame(height: 25.0)
				}

				TabView(selection: $viewModel.tappedIndex) {
					ForEach(0 ..< stepViews.count, id: \.self) { index in
						ZStack {
							let currentStepView = stepViews[index]
							currentStepView
								.onAppear(perform: {})
								.environmentObject(viewModel)
						}
						.clipShape(RoundedRectangle(cornerRadius: 20.0,
						                            style: .continuous))
						.padding(.bottom, 40.0)
					}
					.padding(.all, 10)
				}
				.frame(width: UIScreen.main.bounds.width)
				.tabViewStyle(PageTabViewStyle())
			}
		}
	}
}

// #Preview {
//	let store = Store()
//	let wallet = WalletManager(store: Store())
//
//	CreateStepTabView(stepViews: [CreateStepView(createConfig: .intro),
//	                              CreateStepView(createConfig: .checkboxes)])
// }
