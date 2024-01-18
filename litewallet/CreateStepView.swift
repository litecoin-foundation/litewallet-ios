import SwiftUI

struct CreateStepView: View {
	@EnvironmentObject
	var viewModel: StartViewModel

	var backgroundColor: Color = .litewalletDarkBlue
	var createStepConfig: CreateStepConfig = .intro

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
					if createStepConfig == .intro {
						IntroStepView()
							.environmentObject(viewModel)
					} else if createStepConfig == .checkboxes {
						CheckboxesStepView()
							.environmentObject(viewModel)
					} else if createStepConfig == .seedPhrase {
						SeedPhraseStepView()
							.environmentObject(viewModel)
					} else {
						FinishedStepView()
					}
				}
			}
		}
	}
}

#Preview {
	CreateStepView(createConfig: .intro)
}
