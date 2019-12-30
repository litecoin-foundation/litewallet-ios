//
//  CI.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/30/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import Foundation

struct CI {
    static var mixpanelTokenProdKey:    String = "$(SECRET_MIXPANL_PROD_ENVIRONMENT_KEY)"
    static var mixpanelTokenDevKey:     String = "$(SECRET_MIXPANL_DEV_ENVIRONMENT_KEY)"
    static var newRelicTokenProdKey:    String = "$(SECRET_NR_PROD_ENVIRONMENT_KEY)"
    static var newRelicTokenDevKey:     String = "$(SECRET_NR_DEV_ENVIRONMENT_KEY)"
}
