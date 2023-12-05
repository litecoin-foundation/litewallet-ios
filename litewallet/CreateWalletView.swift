import SwiftUI

struct CreateWalletView: View {
	@ObservedObject
	var createViewModel: CreateWalletViewModel

	private let createStepsArray = [CreateStepView(createConfig: .intro, mainTitle: "Intro : Get Ready", backgroundColor: .yellow),
	                                CreateStepView(createConfig: .checkboxes, mainTitle: "Join the Family", backgroundColor: .orange),
	                                CreateStepView(createConfig: .seedPhrase, mainTitle: "Don't lose this!", backgroundColor: .litewalletDarkBlue),
	                                CreateStepView(createConfig: .finished, mainTitle: "Done", backgroundColor: .litewalletGreen)]
	init(viewModel: CreateWalletViewModel) {
		createViewModel = viewModel
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width

			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)

				LazyHStack {
					CreateStepTabView(stepViews: createStepsArray)
						.frame(width: width * 0.9)
				}
			}
		}
	}
}

#Preview {
	CreateWalletView(viewModel: CreateWalletViewModel())
}
