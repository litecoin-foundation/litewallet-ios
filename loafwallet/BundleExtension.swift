//
//  BundleExtension.swift
//  loafwallet
//
//  Created by Ivan Ferencak on 18.11.2022..
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

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
        let oneToken: String = "com.litecoin.loafwallet"

        DispatchQueue.once(token: oneToken) {
            object_setClass(Bundle.main, BundleEx.self as AnyClass)
        }

        if let temp = language {
            objc_setAssociatedObject(Bundle.main, &_bundle, Bundle(path: Bundle.main.path(forResource: temp, ofType: "lproj")!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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