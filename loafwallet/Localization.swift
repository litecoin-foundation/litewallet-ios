//
//  Localization.swift
//  loafwallet
//
//  Created by Ivan Ferencak on 27.11.2022..
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation

struct Localization {
    let key: String
    let value: String?
    let comment: String?
}

extension Localization {
    func localize() -> String {
        return NSLocalizedString(self.key, value: self.value ?? "", comment: self.comment ?? "")
    }
}
