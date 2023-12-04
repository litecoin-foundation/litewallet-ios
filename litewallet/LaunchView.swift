import SwiftUI

struct LaunchView: View {
	var body: some View {
		GeometryReader { geometry in

			let height = geometry.size.height
			let width = geometry.size.width

			ZStack {
				Color.litewalletBlue.edgesIgnoringSafeArea(.all)
			}
		}
	}
}

#Preview {
	LaunchView()
}
