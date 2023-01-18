import UIKit

extension UIViewController {
	func showErrorMessage(_ message: String) {
		let alert = UIAlertController(title: S.LitewalletAlert.error.localize(), message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: S.Button.ok.localize(), style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	func showAlert(title: String, message: String, buttonLabel _: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: S.Button.ok.localize(), style: .default, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}
