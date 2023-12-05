import SwiftUI

enum CreateStepConfig {
	case intro
	case checkboxes
	case seedPhrase
	case finished
}

struct CreateStepView: View {
	var backgroundColor: Color = .litewalletDarkBlue
	let mainTitle: String
	let detailMessage: String = ""
	let extendedMessage: String = ""
	let createStepConfig: CreateStepConfig

	init(createConfig: CreateStepConfig, mainTitle: String, backgroundColor: Color) {
		createStepConfig = createConfig
		self.mainTitle = mainTitle
		self.backgroundColor = backgroundColor
	}

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				let height = geometry.size.height
				let width = geometry.size.width

				backgroundColor.edgesIgnoringSafeArea(.all)

				VStack {
					Text(mainTitle)
					Spacer()
				}
			}
		}
	}
}

#Preview {
	CreateStepView(createConfig: .intro, mainTitle: "TEST TITLE", backgroundColor: .red)
}
