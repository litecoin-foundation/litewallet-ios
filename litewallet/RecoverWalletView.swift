import SwiftUI

struct RecoverWalletView: View {
	@ObservedObject
	var recoverViewModel: RecoverWalletViewModel

	init(viewModel: RecoverWalletViewModel) {
		recoverViewModel = viewModel
	}

	var body: some View {
		GeometryReader { _ in
			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)
				VStack {
					Text("Recover")
				}
			}
		}
	}
}

#Preview {
	RecoverWalletView(viewModel: RecoverWalletViewModel())
}
