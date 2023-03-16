import SwiftUI

struct ShowSeedView: View {
	let seedPhrase: String

	var dismissAction: (() -> Void)?

	init(seedPhrase: String) {
		self.seedPhrase = seedPhrase
	}

	var body: some View {
		VStack {
			ZStack {
				HStack {
					Spacer()
					Text(S.Settings.seedPhrase.localize())
						.foregroundColor(.white)
						.font(Font(UIFont.barlowBold(size: 24.0)))
						.padding()
					Spacer()
				}

				HStack {
					Button {
						dismissAction?()
					} label: {
						Image("whiteCross")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 15,
							       height: 15)
					}

					Spacer()
				}
				.padding(.all, 10.0)
			}

			Divider()
				.frame(maxHeight: 1.0)
				.background(Color(UIColor.transparentWhite))

			Text(self.seedPhrase)
				.foregroundColor(.white)
				.font(Font(UIFont.barlowSemiBold(size: 16.0)))
				.padding(.bottom, 60)
		}
		.background(Color(UIColor.gray))
		.cornerRadius(6.0)
	}
}

struct ShowSeedView_Previews: PreviewProvider {
	static let seed = "ferrgr grgrg grgrg"
	static var previews: some View {
		ShowSeedView(seedPhrase: seed)
	}
}
