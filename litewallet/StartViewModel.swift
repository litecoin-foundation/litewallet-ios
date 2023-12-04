import Foundation
import UIKit

class StartViewModel: ObservableObject {
	// MARK: - Combine Variables

	// MARK: - Public Variables

	var store: Store

	// MARK: - Private Variables

	init(store: Store) {
		self.store = store
	}
}
