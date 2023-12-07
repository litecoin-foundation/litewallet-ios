import SwiftUI
import UIKit

struct CreateWalletView: View {
	@ObservedObject
	var createViewModel: CreateWalletViewModel

	private let createStepsArray = [CreateStepView(createConfig: .intro),
	                                CreateStepView(createConfig: .checkboxes),
	                                CreateStepView(createConfig: .seedPhrase),
	                                CreateStepView(createConfig: .finished)]
	init(viewModel: CreateWalletViewModel) {
		createViewModel = viewModel
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width

			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)
				HStack {
					CreateStepTabView(stepViews: createStepsArray)
				}
			}
		}
		.environmentObject(createViewModel)
	}
}

#Preview {
	CreateWalletView(viewModel: CreateWalletViewModel())
}
