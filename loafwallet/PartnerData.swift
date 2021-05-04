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
    case infura
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
    
    /// Returns Partner Key
    /// - Parameter name: Enum for the different partners
    /// - Returns: Key string
    static func partnerKeyPath(name: PartnerName) -> String {
        
        switch name {
            
            case .infura:
                
                if let path = Bundle.main.path(forResource: "partner-keys", ofType: "plist"),
                          let dictionary = NSDictionary(contentsOfFile:path) as? Dictionary<String, AnyObject>,
                          let key = dictionary["infura-api"] as? String {
                           return "https://mainnet.infura.io/v3/" + key
                       } else {
                           return "ERROR-INFURA_KEY"
                       }
                 
            case .changeNow:
                
                if let path = Bundle.main.path(forResource: "partner-keys", ofType: "plist"),
                   let dictionary = NSDictionary(contentsOfFile:path) as? Dictionary<String, AnyObject>,
                   let key = dictionary["change-now-api"] as? String {
                    return key
                } else {
                    return "ERROR-CHANGENOW_KEY"
                }
        }
        
    }
     
    //TODO: Uncomment as integration progresses, kcw-grunt
    //    let bitrefillDictionary =
    //      ["title":S.BuyCenter.Cells.bitrefillTitle as AnyObject,
    //       "details":S.BuyCenter.Cells.bitrefillFinancialDetails,
    //       "logo":UIImage(named:"bitrefillLogo") ?? " ",
    //       "baseColor":#colorLiteral(red: 0.2235294118, green: 0.5490196078, blue: 0.9333333333, alpha: 1)] as [String : AnyObject]
}
