import SwiftUI
import UIKit

struct CreateWalletView: View {
	@EnvironmentObject
	var viewModel: StartViewModel

	private let createStepsArray = [CreateStepView(createConfig: .intro),
	                                CreateStepView(createConfig: .checkboxes),
	                                CreateStepView(createConfig: .seedPhrase),
	                                CreateStepView(createConfig: .finished)]
	init() {}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width

			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)
				HStack {
					CreateStepTabView(stepViews: createStepsArray)
						.environmentObject(viewModel)
				}
			}
		}
	}
}

#Preview {
	CreateWalletView()
}
