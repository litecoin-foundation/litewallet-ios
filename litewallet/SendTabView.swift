import SwiftUI

struct SendTabView: View {
	var sendVC = SendLTCViewController()

	private var store: Store?
	init(store: Store) {
		self.store = store
	}

	var body: some View {
		ZStack {
			Color.white.edgesIgnoringSafeArea(.all)
			Text("Send")
		}
	}
}

#Preview {
	SendTabView(store: Store())
}
