//
//  LocaleChangeViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 5/11/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
class LocaleChangeViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    @Published
    var displayName: String = ""
     
    private var updatedLocale: Locale = Locale.current
    
    init() {
        
        let currentLocale = Locale.current
         
        if let regionCode = currentLocale.regionCode,
           let name = currentLocale.localizedString(forRegionCode: regionCode) {
            displayName = name
        } else {
            displayName = "-"
        }
    }
}
