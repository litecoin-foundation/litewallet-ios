import SwiftUI

struct BuyTabView: View {
	@ObservedObject
	var viewModel = BuyViewModel()

	var body: some View {
		ZStack {
			Color.white.edgesIgnoringSafeArea(.all)
			BuyView(viewModel: viewModel)
		}
	}
}

#Preview {
	BuyTabView()
}
