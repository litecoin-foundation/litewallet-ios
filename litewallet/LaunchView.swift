import SwiftUI

struct LaunchView: View {
	var body: some View {
		GeometryReader { _ in
			ZStack {
				Color.litewalletDarkBlue.edgesIgnoringSafeArea(.all)
			}
		}
	}
}

#Preview {
	LaunchView()
}
