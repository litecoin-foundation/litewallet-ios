//
//  CardWalletTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 4/1/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
import Foundation
import SwiftUI
@testable import loafwallet

class CardWalletTests: XCTestCase {
    
    var viewModel: CardViewModel!
    
    let mockWalletDetailsResponseData =
        """
            {
                    "user_id": "fbabf1bc-1b32-40e6-b072-a0127c026a86",
                    "tern_address": "GBI6LADAXTIEOVRTQURCCBP77OVYOI7WBLSMEUXXHWUX7UJRUB4DIXET",
                    "balance": 0.335425,
                    "btc_address": "moEStpdJy3WXgvrM4UMEPJpG6cJkPiuJ8u",
                    "eth_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "bch_address": "bchtest:qrn7u2kpkf6lrudytt74z6qadvse3t6whs370a3pnk",
                    "ltc_address": "mnUMriUAdmfXbodgbmKgrYsDHbEcu51XxJ",
                    "created_at": "2020-07-12 23:38:05",
                    "updated_at": "2020-07-12 23:38:05",
                    "xrp_tag": 983056520,
                    "xlm_memo": 503240710,
                    "bank_balance": null,
                    "bank_pending_balance": null,
                    "bank_account_number": null,
                    "available_balance": 0.335425,
                    "available_balance_usd": 0,
                    "withdrawable_balance": 0,
                    "withdrawable_balance_usd": 0,
                    "spendable_balance": 0,
                    "spendable_balance_usd": 0,
                    "bat_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "usdc_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "usdt_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "pax_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "tusd_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "dai_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
                    "tern_memo": 503240710,
                    "xlm_address": "GBI6LADAXTIEOVRTQURCCBP77OVYOI7WBLSMEUXXHWUX7UJRUB4DIXET",
                    "xrp_address": "rE8xLDU9d4UCtqtiH5Tz8aRHMNfq7PQH8c",
                    "ach_routing_number": null,
                    "ach_account_status": null
                }
        """.data(using: .utf8)
      
    func testDecodeWalletDetails() throws {
         
        do {
             
            let decoder = JSONDecoder()
            
            guard let data = mockWalletDetailsResponseData else {
                return
            }
            
            let walletDetails = try? decoder.decode(CardWalletDetails.self, from: data)
            
            XCTAssertNotNil(walletDetails)
            
        } catch {
            XCTFail("Decoding failed")
        }
        
    }

}

// DEV: Raw data from user/user_ID/wallet
// Reference in case the schema changes
//    {
//    "data": {
//    "user_id": "fbabf1bc-1b32-40e6-b072-a0127c026a86",
//    "tern_address": "GBI6LADAXTIEOVRTQURCCBP77OVYOI7WBLSMEUXXHWUX7UJRUB4DIXET",
//    "balance": 0,
//    "btc_address": "moEStpdJy3WXgvrM4UMEPJpG6cJkPiuJ8u",
//    "eth_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "bch_address": "bchtest:qrn7u2kpkf6lrudytt74z6qadvse3t6whs370a3pnk",
//    "ltc_address": "mnUMriUAdmfXbodgbmKgrYsDHbEcu51XxJ",
//    "created_at": "2020-07-12 23:38:05",
//    "updated_at": "2020-07-12 23:38:05",
//    "xrp_tag": 983056520,
//    "xlm_memo": 503240710,
//    "bank_balance": null,
//    "bank_pending_balance": null,
//    "bank_account_number": null,
//    "available_balance": 0,
//    "available_balance_usd": 0,
//    "withdrawable_balance": 0,
//    "withdrawable_balance_usd": 0,
//    "spendable_balance": 0,
//    "spendable_balance_usd": 0,
//    "bat_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "usdc_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "usdt_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "pax_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "tusd_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "dai_address": "0x08598f771bd2481026369552DdDEE52d2c32AA01",
//    "tern_memo": 503240710,
//    "xlm_address": "GBI6LADAXTIEOVRTQURCCBP77OVYOI7WBLSMEUXXHWUX7UJRUB4DIXET",
//    "xrp_address": "rE8xLDU9d4UCtqtiH5Tz8aRHMNfq7PQH8c",
//    "ach_routing_number": null,
//    "ach_account_status": null
//    },
//    "meta": {
//    "version": "1.0.2",
//    "received": null,
//    "executed": 1617288226373
//    },
//    "response": {
//    "code": 200,
//    "errors": {},
//    "message": "OK"
//    }
//    }

