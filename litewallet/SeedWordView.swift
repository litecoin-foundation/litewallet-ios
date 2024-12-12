import Foundation
import SwiftUI

struct SeedWord: Identifiable {
	let id = UUID()
	let word: String
	let tagNumber: Int
}

struct SeedWordView: View {
	let seedWord: String
	let wordNumber: Int
	let genericPad = 55.0
	let cellHeight = 45.0
	let offsetPad = 15.0
	let topPad = -11.0

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height
			ZStack {
				VStack {
					ZStack {
						RoundedRectangle(cornerRadius: bigButtonCornerRadius)
							.frame(height: cellHeight, alignment: .center)
							.foregroundColor(.litecoinSilver)
							.shadow(radius: 3, x: 3.0, y: 3.0)

						Text(seedWord)
							.frame(height: cellHeight, alignment: .center)
							.font(.barlowSemiBold(size: 16.0))
							.foregroundColor(.black)

						VStack {
							HStack {
								Text("\(wordNumber)")
									.font(.barlowSemiBold(size: 14.0))
									.foregroundColor(.litecoinDarkSilver)
									.frame(width: genericPad,
									       height: cellHeight,
									       alignment: .leading)
									.offset(x: offsetPad,
									        y: topPad)
								Spacer()
							}
						}
					}
				}
				.frame(width: width, height: height)
				.padding(.all, genericPad)
			}
			.frame(width: width, height: height)
		}
	}
}

// #Preview {
//	SeedWordView(seedWord: SeedWord(word: "banana"), wordNumber: 1)
// }
