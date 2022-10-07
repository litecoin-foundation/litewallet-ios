//
//  ParnterData.swift
//  breadwallet
//
//  Created by Kerry Washington on 9/30/18.
//  Copyright © 2018 breadwallet LLC. All rights reserved.
//

import Foundation
import UIKit 

enum PartnerName {
    case unstop
    case changeNow
}
 
struct Partner {
    
    let logo: UIImage
    let headerTitle: String
    let details: String
    
    /// Fills partner data
    /// - Returns: Array of Partner Data
    static func partnerDataArray() -> [Partner] {
        let moonpay = Partner(logo: UIImage(named: "moonpay-logo")!, headerTitle: S.BuyCenter.Cells.moonpayTitle, details: S.BuyCenter.Cells.moonpayFinancialDetails)
        let simplex = Partner(logo: UIImage(named: "simplexLogo")!, headerTitle: S.BuyCenter.Cells.simplexTitle, details: S.BuyCenter.Cells.simplexFinancialDetails)
        return [moonpay, simplex]
    }
    
    //TODO: Uncomment as integration progresses, kcw-grunt
    //    let bitrefillDictionary =
    //      ["title":S.BuyCenter.Cells.bitrefillTitle as AnyObject,
    //       "details":S.BuyCenter.Cells.bitrefillFinancialDetails,
    //       "logo":UIImage(named:"bitrefillLogo") ?? " ",
    //       "baseColor":#colorLiteral(red: 0.2235294118, green: 0.5490196078, blue: 0.9333333333, alpha: 1)] as [String : AnyObject]
}

