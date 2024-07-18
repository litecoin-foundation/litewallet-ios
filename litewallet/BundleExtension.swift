import Foundation

var _bundle: UInt8 = 0

class BundleEx: Bundle {
	override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
		let bundle: Bundle? = objc_getAssociatedObject(self, &_bundle) as? Bundle

		if let temp = bundle {
			return temp.localizedString(forKey: key, value: value, table: tableName)
		} else {
			return super.localizedString(forKey: key, value: value, table: tableName)
		}
	}
}

public extension Bundle {
	class func setLanguage(_ language: String?) {
		let oneToken = "com.litecoin.loafwallet"

		DispatchQueue.once(token: oneToken) {
			object_setClass(Bundle.main, BundleEx.self as AnyClass)
		}

		if var temp = language {
			if temp == "zh" {
				temp = "zh-Hans"
			}

			guard let path = Bundle.main.path(forResource: temp, ofType: "lproj") else {
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR)
				return
			}
			guard let bundle = Bundle(path: path) else {
				LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR)
				return
			}
			objc_setAssociatedObject(Bundle.main, &_bundle, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		} else {
			objc_setAssociatedObject(Bundle.main, &_bundle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}

extension DispatchQueue {
	private static var _onceTracker = [String]()

	class func once(token: String, block: () -> Void) {
		objc_sync_enter(self); defer { objc_sync_exit(self) }

		if _onceTracker.contains(token) {
			return
		}

		_onceTracker.append(token)
		block()
	}
}
