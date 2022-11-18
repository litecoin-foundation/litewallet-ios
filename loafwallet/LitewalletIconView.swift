import SwiftUI

struct LitewalletIconView: View {
	var body: some View {
		RoundedRectangle(cornerRadius: 11)
			.frame(width: 72.0,
			       height: 72.0,
			       alignment: .center)
			.foregroundColor(.white)
			.shadow(radius: 1.0, x: 2.0, y: 2.0)
			.overlay(
				// Litewallet Icon
				Image("coinBlueWhite")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 60, height: 60)
			)
	}
}

struct LitewalletIconView_Previews: PreviewProvider {
	static var previews: some View {
		LitewalletIconView()
	}
}
