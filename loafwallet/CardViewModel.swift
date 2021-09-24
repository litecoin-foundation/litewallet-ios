//
//  CardViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import KeychainAccess
<<<<<<< HEAD

class CardViewModel: ObservableObject {
        
    //MARK: - Combine Variables
=======
 

class CardViewModel: ObservableObject {
    
    //MARK: - Login Status
>>>>>>> main
    @Published
    var isLoggedIn: Bool = false
    
    @Published
    var isNotRegistered: Bool = true
      
<<<<<<< HEAD
    @Published
    var cardWalletDetails: CardWalletDetails?
    
    @Published
    var litewalletBalance: Double = 0.0
     
    @ObservedObject
    var cardTwoFactor = CardTwoFactor()
     
    //MARK: - Public Variables
    var walletManager: WalletManager
    
    var store: Store 
     
    init(walletManager: WalletManager,
         store: Store) {
        
        self.walletManager = walletManager
        
        self.store = store
        
        calculatedLitewalletBalance()
    }
    
    func calculatedLitewalletBalance() {
        
        if let balance = walletManager.wallet?.balance,
           let rate =  store.state.currentRate {
            
            self.litewalletBalance = Amount(amount: balance,
                                            rate: rate,
                                            maxDigits: store.state.maxDigits).amountForLtcFormat
        }
    }
    
    /// Fetch Card Wallet details from the Ternio server
    /// - Parameter completion: All is well
    func fetchCardWalletDetails(completion: @escaping () -> Void) {
         
        let keychain = Keychain(service: "com.litecoincard.service")
          
        // Fetches the latest token and UserID
        guard let token = keychain["token"] ,
              let userID = keychain["userID"] else {
            LWAnalytics.logEventWithParameters(itemName:._20210804_ERR_KLF)
            return
        }
         
        PartnerAPI.shared.getWalletDetails(userID: userID, token: token) { detailsDict in
            
            //Only receives the data element there is the metadata
            guard let data = detailsDict?["data"] as? [String: Any] else {
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF)
=======
    //MARK: - Combine Variables
    @Published
    var walletDetails: CardWalletDetails?
     
    init() { }
    
    func fetchCardWalletDetails(completion: @escaping () -> Void) {
        
        let cardService = "com.litecoincard.service"
        let keychain = Keychain(service: cardService)
        
        guard let token = (try? keychain.getString("token")) as? String else {
            print("Error: Token not found")
            return
        }
        
        guard let userID = (try? keychain.getString("userID")) as? String else {
            print("Error: UserID not found")
            return
        }
        
        PartnerAPI.shared.getWalletDetails(userID: userID, token: token) { detailsDict in
            
            //Only reteives the data element there is the metadata and the result as well
            guard let data = detailsDict?["data"] as? [String: Any] else {
                print("Error: Data dict not found")
>>>>>>> main
                return
            }
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: data, options:[])
                
                let decoder = JSONDecoder() 
                
                let walletDetails = try? decoder.decode(CardWalletDetails.self, from: jsonData)
                
<<<<<<< HEAD
                DispatchQueue.main.async { 
                    self.cardWalletDetails = walletDetails
                    LWAnalytics.logEventWithParameters(itemName:._20210804_TAWDS)
                }
                
=======
                DispatchQueue.main.async {
                    self.walletDetails = walletDetails
                }
>>>>>>> main
            } catch {
                print("Error: Incomplete dictionary data from partner API")
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF) 
            }
        }
    }
}
