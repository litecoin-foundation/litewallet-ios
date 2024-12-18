import FirebaseRemoteConfig
import Foundation
import KeychainAccess
import UIKit

enum RemoteConfigKeys: String {
	case KEY_FEATURE_MENU_HIDDEN_EXAMPLE = "feature_menu_hidden_example"
	case KEY_API_BASEURL_PROD_NEW_ENABLED = "key_api_baseurl_prod_new_enabled"
	case KEY_API_BASEURL_DEV_NEW_ENABLED = "key_api_baseurl_dev_new_enabled"
	case KEY_KEYSTORE_MANAGER_ENABLED = "key_keystore_manager_enabled"
	case KEY_PROD_API_BASEURL = "key_prod_api_baseurl"
	case KEY_DEV_API_BASEURL = "key_dev_api_baseurl"
}

class RemoteConfigHelper: NSObject {
	static let sharedInstance = RemoteConfigHelper()

	private var remoteConfig: RemoteConfig!
	private let settings = RemoteConfigSettings()
	private let keychainEnvironment = Keychain(service: "litewallet.environment")
	private let debugFetchInterval: TimeInterval = 0 // seconds
	private let productionFetchInterval: TimeInterval = 60 * 180 // seconds; Fetch every 3 hours in production mode
	override init() {
		super.init()
		remoteConfig = RemoteConfig.remoteConfig()
		setupRemoteConfig()
	}

	deinit {}

	private func setupRemoteConfig() {
		remoteConfig.setDefaults(fromPlist: "remote-config-defaults")
		#if DEBUG
			settings.minimumFetchInterval = debugFetchInterval
		#else
			settings.minimumFetchInterval = productionFetchInterval
		#endif

		remoteConfig.configSettings = settings

		/// Call the first time
		fetchAndActivateRemoteConfig()

		/// Update based on remote changes
		remoteConfig.addOnConfigUpdateListener { configUpdate, error in
			guard let configUpdate, error == nil else {
				let errorDict: [String: String] = ["error": error?.localizedDescription ?? ""]
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: errorDict)
				return
			}

			self.fetchAndActivateRemoteConfig()
		}
	}

	private func fetchAndActivateRemoteConfig() {
		remoteConfig.fetch { status, error in
			if status == .success {
				self.remoteConfig.activate { _, error in
					guard error == nil else { return }
					DispatchQueue.main.async {
						LWAnalytics.logEventWithParameters(itemName: ._20241213_RCC)
					}
				}
			} else {
				let errorDict: [String: String] = ["error": error?.localizedDescription ?? ""]
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: errorDict)
			}
		}
	}

	func getString(key: String) -> String {
		return remoteConfig[key].stringValue ?? "value_not_found"
	}

	func getNumber(key: String) -> NSNumber {
		return remoteConfig[key].numberValue
	}

	func getBool(key: String) -> Bool {
		return remoteConfig[key].boolValue
	}
}
