//
//  UIApplication+Extension.swift
//  loafwallet
//
//  Created by Kerry Washington on 4/3/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
