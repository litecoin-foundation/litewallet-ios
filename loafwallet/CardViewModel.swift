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

/// Enum displaying the states of the card and wallet balances
enum WalletBalanceStatus: Int {
    case litewalletAndCardEmpty
    case cardWalletEmpty
    case litewalletEmpty
    case litewalletAndCardNonZero
}

class CardViewModel: ObservableObject {
        
    //MARK: - Login Status
    @Published
    var isLoggedIn: Bool = false
    
    @Published
    var isNotRegistered: Bool = true
      
    //MARK: - Combine Variables
    @Published
    var cardWalletDetails: CardWalletDetails?
     
    @Published
    var walletBalanceStatus: WalletBalanceStatus?
      
    //MARK: - Public Variables
    
    /// Amount class contains LTC,  fiat rate, etc.
    var litewalletAmount: Amount
    
    var walletManager: WalletManager
     
    init(litewalletAmount: Amount, walletManager: WalletManager) {
        
        self.litewalletAmount = litewalletAmount
        
        self.walletManager = walletManager
    }
    
    
    /// Fetcht Balance Status (litewallet balance injected)
    /// - Parameter cardBalance: Fetched users Litecoin Card balance
    /// - Returns: enum of the status WalletBalanceStatus
    private func fetchBalanceStatus(cardBalance: Double) -> WalletBalanceStatus {
          
        switch (cardBalance, litewalletAmount) {
            case _ where cardBalance == 0.0 &&
                    litewalletAmount.amountForLtcFormat == 0.0:
                return .litewalletAndCardEmpty
            case _ where cardBalance > 0.0 &&
                    litewalletAmount.amountForLtcFormat == 0.0:
                return .litewalletEmpty
            case _ where cardBalance == 0.0 &&
                    litewalletAmount.amountForLtcFormat > 0.0:
                return .cardWalletEmpty
            case _ where cardBalance > 0.0 &&
                    litewalletAmount.amountForLtcFormat > 0.0:
                return .litewalletAndCardNonZero
            default:
                return .cardWalletEmpty
        }

    }
    
    
    /// Fetch Card Wallet details from the Ternio server
    /// - Parameter completion: All is well
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
            
            //Only receives the data element there is the metadata
            guard let data = detailsDict?["data"] as? [String: Any] else {
                print("Error: Data dict not found")
                return
            }
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: data, options:[])
                
                let decoder = JSONDecoder() 
                
                let walletDetails = try? decoder.decode(CardWalletDetails.self, from: jsonData)
                
                DispatchQueue.main.async {
                    
                    self.cardWalletDetails = walletDetails
                    
                    let availableCardBalance: Double = self.cardWalletDetails?.availableBalance ?? 0.0
                    
                    // Set the wallet status for the view.
                    self.walletBalanceStatus = self.fetchBalanceStatus(cardBalance: availableCardBalance)
                    
                }
                
            } catch {
                print("Error: Incomplete dictionary data from partner API")
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF) 
            }
        }
    }
}
