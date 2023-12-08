import Foundation
import SwiftUI

struct SeedWord: Identifiable {
	let id = UUID()
	let word: String
}

struct SeedWordView: View {
	let seedWord: SeedWord

	var body: some View {
		GeometryReader { _ in

			ZStack {
				VStack {
					ZStack {
						RoundedRectangle(cornerRadius: bigButtonCornerRadius)
							.frame(height: 45, alignment: .center)
							.foregroundColor(.red)
							.shadow(radius: 3, x: 3.0, y: 3.0)

						Text(seedWord.word)
							.frame(height: 45, alignment: .center)
							.font(.barlowSemiBold(size: 16.0))
							.foregroundColor(.black)
					}
				}
			}
		}
	}
}

#Preview {
	SeedWordView(seedWord: SeedWord(word: "banana"))
}
