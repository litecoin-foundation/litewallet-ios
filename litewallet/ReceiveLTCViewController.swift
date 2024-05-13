import UIKit

class ReceiveLTCViewController: UIViewController {
	var store: Store?
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_: Bool) {
		guard let store = store
		else {
			NSLog("ERROR: Store is not initialized")
			return
		}

		store.perform(action: RootModalActions.Present(modal: .receive))
	}
}
