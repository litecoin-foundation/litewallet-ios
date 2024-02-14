import AVFoundation
import Foundation
import SwiftUI
import UIKit

class LoginViewModel: ObservableObject {
	// MARK: - Combine Variables

	var store: Store
	var walletManager: WalletManager?
	var isPresentedForLock: Bool

	init(store: Store, isPresentedForLock: Bool, walletManager: WalletManager?) {
		self.store = store
		self.walletManager = walletManager
		self.isPresentedForLock = isPresentedForLock
	}
}
