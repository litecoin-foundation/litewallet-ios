import Firebase
import FirebaseCore
import FirebaseMessaging
import LocalAuthentication
import SwiftUI
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
	var window: UIWindow?
	let applicationController = ApplicationController()
	let gcmMessageIDKey = "gcm.litewawllet_message_id"

	var resourceRequest: NSBundleResourceRequest?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		requestResourceWith(tag: ["initial-resources", "speakTag"]) { [self] in

			// Language
			updateCurrentUserLocale(localeId: Locale.current.identifier)
			Bundle.setLanguage(UserDefaults.selectedLanguage)

			// Ops
			let startDate = Partner.partnerKeyPath(name: .litewalletStart)
			if startDate == "error-litewallet-start-key" {
				let errorDescription = "partnerkey_data_missing"
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["error": errorDescription])
			}

			// Call Firebase
			self.setFirebaseConfigurationMethod()

		} onFailure: { error in

			let properties: [String: String] = ["error_type": "on_demand_resources_not_found",
			                                    "error_description": "\(error.debugDescription)"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR,
			                                   properties: properties)
		}

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

	func application(_: UIApplication, shouldAllowExtensionPointIdentifier _: UIApplication.ExtensionPointIdentifier) -> Bool {
		return false // disable extensions such as custom keyboards for security purposes
	}

	func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		return applicationController.open(url: url)
	}

	func application(_: UIApplication, shouldSaveApplicationState _: NSCoder) -> Bool {
		return true
	}

	func application(_: UIApplication, shouldRestoreApplicationState _: NSCoder) -> Bool {
		return true
	}

	func application(_: UIApplication,
	                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
	{
		let acceptanceDict: [String: String] = ["did_accept": "true",
		                                        "date_accepted": Date().ISO8601Format(),
		                                        "apns_token_status": "\(deviceToken)"]
		LWAnalytics.logEventWithParameters(itemName: ._20231225_UAP, properties: acceptanceDict)
	}

	func application(_: UIApplication,
	                 didFailToRegisterForRemoteNotificationsWithError error: Error)
	{
		print("Unable to register for remote notifications: \(error.localizedDescription)")
	}

	func application(_: UIApplication,
	                 didReceiveRemoteNotification userInfo: [AnyHashable: Any])
	{
		/// Print message ID.
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID) \n \(userInfo)")
		}
	}

	/// Sets the correct Google Services  plist file
	private func setFirebaseConfigurationMethod() {
		// Load a Firebase debug config file.
		// let filePath = Bundle.main.path(forResource: "Debug-GoogleService-Info", ofType: "plist")
		guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
			let properties = ["error_message": "gs_info_file_missing"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR,
			                                   properties: properties)
			assertionFailure("Couldn't load google services file")
			return
		}

		if let fboptions = FirebaseOptions(contentsOfFile: filePath) {
			FirebaseApp.configure(options: fboptions)

			Messaging.messaging().delegate = self
			UNUserNotificationCenter.current().delegate = self

			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: { _, _ in }
			)

		} else {
			let properties = ["error_message": "firebase_config_failed"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR,
			                                   properties: properties)
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

	/// On Demand Resources
	/// Use for another resource heavy view
	/// Inspired by https://www.youtube.com/watch?v=B5RV8p4-9a8&t=178s
	func requestResourceWith(tag: [String],
	                         onSuccess: @escaping () -> Void,
	                         onFailure _: @escaping (NSError) -> Void)
	{
		resourceRequest = NSBundleResourceRequest(tags: Set(tag))

		guard let request = resourceRequest else { return }

		request.endAccessingResources()
		request.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
		request.conditionallyBeginAccessingResources { areResourcesAvailable in

			DispatchQueue.main.async {
				if !areResourcesAvailable {
					request.beginAccessingResources { error in
						guard error != nil else {
							let properties: [String: String] = ["error_type": "on_demand_resources_not_found",
							                                    "error_description": "\(error.debugDescription)"]
							LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR,
							                                   properties: properties)

							return
						}
						onSuccess()
					}
				} else {
					onSuccess()
				}
			}
		}
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_: UNUserNotificationCenter,
	                            willPresent notification: UNNotification) async
		-> UNNotificationPresentationOptions
	{
		let userInfo = notification.request.content.userInfo
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID) \n \(userInfo)")
		}

		// All options
		return [[.badge, .sound, .banner]]
	}

	func userNotificationCenter(_: UNUserNotificationCenter,
	                            didReceive response: UNNotificationResponse) async
	{
		let userInfo = response.notification.request.content.userInfo

		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID) \n \(userInfo)")
		}
	}
}
