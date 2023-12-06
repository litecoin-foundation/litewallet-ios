import SwiftUI

struct CreateStepView: View {
	@EnvironmentObject
	var createViewModel: CreateWalletViewModel

	@State
	private var shouldShowCheckbox = false

	@State
	private var shouldTest = false

	var backgroundColor: Color = .litewalletDarkBlue
	let createStepConfig: CreateStepConfig

	let hugeFont = Font.barlowBold(size: 30.0)

	init(createConfig: CreateStepConfig) {
		createStepConfig = createConfig
	}

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				let height = geometry.size.height
				let width = geometry.size.width

				createStepConfig.backgroundColor
					.edgesIgnoringSafeArea(.all)

				VStack {
					Text("createStepConfig.mainTitle")
						.font(hugeFont)
					Text(createStepConfig.detailMessage)
						.font(.subheadline)
					Text(createStepConfig.extendedMessage)

					Spacer()
				}
			}
		}
	}
}

#Preview {
	CreateStepView(createConfig: .intro)
}
