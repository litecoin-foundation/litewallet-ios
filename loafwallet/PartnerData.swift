//
//  ParnterData.swift
//  breadwallet
//
//  Created by Kerry Washington on 9/30/18.
//  Copyright © 2018 breadwallet LLC. All rights reserved.
//

import Foundation
import UIKit
 
struct Partner {
    
    let logo: UIImage
    let headerTitle: String
    let details: String
     
    static func partnerDataArray() -> [Partner] {
        let moonpay = Partner(logo: UIImage(named: "moonpay-logo")!, headerTitle: S.BuyCenter.Cells.moonpayTitle, details: S.BuyCenter.Cells.moonpayFinancialDetails)
        let simplex = Partner(logo: UIImage(named: "simplexLogo")!, headerTitle: S.BuyCenter.Cells.simplexTitle, details: S.BuyCenter.Cells.simplexFinancialDetails)
        return [moonpay, simplex]
    }
     
//TODO: Uncomment as integration progresses, kcw-grunt
//    let coinbaseDictionary =
//      ["title":S.BuyCenter.Cells.coinbaseTitle as AnyObject,
//       "details":S.BuyCenter.Cells.coinbaseFinancialDetails,
//       "logo":UIImage(named: "coinbaseLogo") ?? " ",
//       "baseColor":#colorLiteral(red: 0.07843137255, green: 0.4156862745, blue: 0.8039215686, alpha: 1)] as [String : AnyObject]

//    let changellyDictionary =
//      ["title":S.BuyCenter.Cells.changellyTitle as AnyObject,
//       "details":S.BuyCenter.Cells.changellyFinancialDetails,
//       "logo":UIImage(named:"changellyLogo") ?? " ",
//       "baseColor":#colorLiteral(red: 0.07058823529, green: 0.7882352941, blue: 0.4274509804, alpha: 1)] as [String : AnyObject]
//    let bitrefillDictionary =
//      ["title":S.BuyCenter.Cells.bitrefillTitle as AnyObject,
//       "details":S.BuyCenter.Cells.bitrefillFinancialDetails,
//       "logo":UIImage(named:"bitrefillLogo") ?? " ",
//       "baseColor":#colorLiteral(red: 0.2235294118, green: 0.5490196078, blue: 0.9333333333, alpha: 1)] as [String : AnyObject]
}
