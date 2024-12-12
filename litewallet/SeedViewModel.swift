import Foundation

import AVFoundation
import Foundation
import SwiftUI
import UIKit

class SeedViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var seedWords: [SeedWord] = [SeedWord(word: "banana", tagNumber: 0),
	                             SeedWord(word: "banana", tagNumber: 1),
	                             SeedWord(word: "banana", tagNumber: 2),
	                             SeedWord(word: "banana", tagNumber: 3),
	                             SeedWord(word: "banana", tagNumber: 4),
	                             SeedWord(word: "banana", tagNumber: 5),
	                             SeedWord(word: "banana", tagNumber: 6),
	                             SeedWord(word: "banana", tagNumber: 7),
	                             SeedWord(word: "banana", tagNumber: 8),
	                             SeedWord(word: "banana", tagNumber: 9),
	                             SeedWord(word: "banana", tagNumber: 10),
	                             SeedWord(word: "banana", tagNumber: 11)]

	@Binding
	var enteredPIN: String

	init(enteredPIN: Binding<String>) {
		_enteredPIN = enteredPIN
	}

	func fetchWords(walletManager: WalletManager, appPIN: String) -> [SeedWord]? {
		if let words = walletManager.seedPhrase(pin: appPIN) {
			let wordArray = words.components(separatedBy: " ")
			seedWords.removeAll()

			for (index, word) in wordArray.enumerated() {
				seedWords.append(SeedWord(word: "\(word)", tagNumber: index + 1))
			}
			return seedWords
		}
		return nil
	}
}
