import Firebase
import LocalAuthentication
import
import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	let applicationController = ApplicationController()
	let pushNotifications = PushNotifications.shared
	func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		setFirebaseConfiguration()

		updateCurrentUserLocale(localeId: Locale.current.identifier)

		guard let thisWindow = window else { return false }

		thisWindow.tintColor = .liteWalletBlue

		UIView.swizzleSetFrame()

		applicationController.launch(application: application, window: thisWindow)

		LWAnalytics.logEventWithParameters(itemName: ._20191105_AL)

		Bundle.setLanguage(UserDefaults.selectedLanguage)

		// Pusher
		pushNotifications.start(instanceId: Partner.partnerKeyPath(name: .pusherStaging))
		// pushNotifications.registerForRemoteNotifications()
		let generaliOSInterest = "general-ios"
		let debugGeneraliOSInterest = "debug-general-ios"

		try? pushNotifications
			.addDeviceInterest(interest: generaliOSInterest)
		try? pushNotifications
			.addDeviceInterest(interest: debugGeneraliOSInterest)

		let interests = pushNotifications.getDeviceInterests()?.joined(separator: "|") ?? ""
		let device = UIDevice.current.identifierForVendor?.uuidString ?? "ID"
		let interestesDict: [String: String] = ["device_id": device,
		                                        "pusher_interests": interests]

		LWAnalytics.logEventWithParameters(itemName: ._20231202_RIGI, properties: interestesDict)

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

	/// Pusher Related funcs
	func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		pushNotifications.registerDeviceToken(deviceToken)

		let acceptanceDict: [String: String] = ["did_accept": "true",
		                                        "date_accepted": Date().ISO8601Format()]
		LWAnalytics.logEventWithParameters(itemName: ._20231225_UAP, properties: acceptanceDict)
	}

	func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
	                 fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void)
	{
		pushNotifications.handleNotification(userInfo: userInfo)
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
