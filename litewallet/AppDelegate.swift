import Firebase
import LocalAuthentication
import PushNotifications
import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	let applicationController = ApplicationController()
	// FIXME: - Waiting for Pusher to respond:  https://github.com/pusher/push-notifications-swift/issues/187
	// let pushNotifications = PushNotifications.shared

	func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		UINavigationBar.appearance().tintColor = .darkText

		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.titleTextAttributes = [.foregroundColor: UIColor.darkText]
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance

		setFirebaseConfiguration()

		updateCurrentUserLocale(localeId: Locale.current.identifier)

		guard let thisWindow = window else { return false }

		thisWindow.tintColor = .liteWalletBlue

		UIView.swizzleSetFrame()

		applicationController.launch(application: application, window: thisWindow)

		LWAnalytics.logEventWithParameters(itemName: ._20191105_AL)

		Bundle.setLanguage(UserDefaults.selectedLanguage)

		// "bbac5210-989c-49d5-a336-ae1eaf81e586"

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

	func application(_: UIApplication, shouldAllowExtensionPointIdentifier _: UIApplication.ExtensionPointIdentifier) -> Bool
	{
		return false // disable extensions such as custom keyboards for security purposes
	}

	func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
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
