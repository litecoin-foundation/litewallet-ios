import Firebase
import LocalAuthentication
import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	let applicationController = ApplicationController()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		setFirebaseConfiguration()

		updateCurrentUserLocale(localeId: Locale.current.identifier)

		guard let thisWindow = window else { return false }

		thisWindow.tintColor = .liteWalletBlue

		UIView.swizzleSetFrame()

		applicationController.launch(application: application, window: thisWindow)

		LWAnalytics.logEventWithParameters(itemName: ._20191105_AL)

		return true
	}

	func applicationDidBecomeActive(_: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}

	func applicationWillEnterForeground(_: UIApplication) {
		applicationController.willEnterForeground()
	}

	func applicationDidEnterBackground(_: UIApplication) {
		applicationController.didEnterBackground()
	}

	func applicationWillResignActive(_: UIApplication) {
		applicationController.willResignActive()
	}

	func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
	{
		applicationController.performFetch(completionHandler)
	}

	func application(_: UIApplication, shouldAllowExtensionPointIdentifier _: UIApplicationExtensionPointIdentifier) -> Bool
	{
		return false // disable extensions such as custom keyboards for security purposes
	}

	func application(_: UIApplication, open url: URL, options _: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool
	{
		return applicationController.open(url: url)
	}

	func application(_: UIApplication, shouldSaveApplicationState _: NSCoder) -> Bool {
		return true
	}

	func application(_: UIApplication, shouldRestoreApplicationState _: NSCoder) -> Bool {
		return true
	}

	/// Sets the correct Google Services  plist file
	private func setFirebaseConfiguration() {
		// Load a Firebase debug config file.
		// let filePath = Bundle.main.path(forResource: "Debug-GoogleService-Info", ofType: "plist")

		let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")

		if let fboptions = FirebaseOptions(contentsOfFile: filePath!) {
			FirebaseApp.configure(options: fboptions)
		} else {
			assertionFailure("Couldn't load Firebase config file")
		}
	}

	/// Check Locale
	func updateCurrentUserLocale(localeId: String) {
		let suffix = String(localeId.suffix(3))

		if suffix == "_US" {
			UserDefaults.userIsInUSA = true
		} else {
			UserDefaults.userIsInUSA = false
		}
	}
}
