import Firebase
import LocalAuthentication
import PushNotifications
import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	let applicationController = ApplicationController()
	let pushNotifications = PushNotifications.shared

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
			// Firebase
			self.setFirebaseConfiguration()

			// Pusher
			self.pushNotifications.start(instanceId: Partner.partnerKeyPath(name: .pusher))
			let generalInterest = String.preferredLanguageInterest(currentId: UserDefaults.selectedLanguage)
			let debugGeneralInterest = "debug-general"

			try? self.pushNotifications.clearDeviceInterests()

			try? self.pushNotifications
				.addDeviceInterest(interest: generalInterest)
			try? self.pushNotifications
				.addDeviceInterest(interest: debugGeneralInterest)

			let interests = self.pushNotifications.getDeviceInterests()?.joined(separator: "|") ?? ""
			let device = UIDevice.current.identifierForVendor?.uuidString ?? "ID"
			let interestsDict: [String: String] = ["device_id": device,
			                                       "pusher_interests": interests]

			LWAnalytics.logEventWithParameters(itemName: ._20231202_RIGI,
			                                   properties: interestsDict)

			let current = UNUserNotificationCenter.current()

			current.getNotificationSettings(completionHandler: { settings in

				debugPrint(settings.debugDescription)
				if settings.authorizationStatus == .denied {
					self.pushNotifications.clearAllState {
						LWAnalytics.logEventWithParameters(itemName: ._20240506_DPN)
					}

					self.pushNotifications.stop {
						LWAnalytics.logEventWithParameters(itemName: ._20240510_SPN)
					}
				}
			})

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

		guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
			let properties = ["error_message": "gs_info_file_missing"]
			LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR,
			                                   properties: properties)
			assertionFailure("Couldn't load google services file")
			return
		}

		if let fboptions = FirebaseOptions(contentsOfFile: filePath) {
			FirebaseApp.configure(options: fboptions)
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
