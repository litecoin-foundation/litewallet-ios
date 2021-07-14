//
//  BRBitID.swift
//  BreadWallet
//
//  Created by Samuel Sutch on 6/17/16.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import Security
import BRCore


open class BRBitID : NSObject {
    static let SCHEME = "bitid"
    static let PARAM_NONCE = "x"
    static let PARAM_UNSECURE = "u"
    static let USER_DEFAULTS_NONCE_KEY = "brbitid_nonces"
    static let DEFAULT_INDEX: UInt32 = 42
    
    class func isBitIDURL(_ url: URL!) -> Bool {
        return url.scheme == SCHEME
    }
    
    static let BITCOIN_SIGNED_MESSAGE_HEADER = "Bitcoin Signed Message:\n".data(using: String.Encoding.utf8)!
    
    class func formatMessageForBitcoinSigning(_ message: String) -> Data {
        let data = NSMutableData()
        var messageHeaderCount = UInt8(BITCOIN_SIGNED_MESSAGE_HEADER.count)
        data.append(NSData(bytes: &messageHeaderCount, length: MemoryLayout<UInt8>.size) as Data)
        data.append(BITCOIN_SIGNED_MESSAGE_HEADER)
        let msgBytes = message.data(using: String.Encoding.utf8)!
        data.appendVarInt(i: UInt64(msgBytes.count))
        data.append(msgBytes)
        return data as Data
    }
    
    // sign a message with a key and return a base64 representation
    class func signMessage(_ message: String, usingKey key: BRKey) -> String {
        let signingData = formatMessageForBitcoinSigning(message)
        let signature = signingData.sha256_2.compactSign(key: key)
        return String(bytes: signature.base64EncodedData(options: []), encoding: String.Encoding.utf8) ?? ""
    }
    
    let url: URL
    let walletManager: WalletManager
    
    open var siteName: String {
        return "\(url.host!)\(url.path)"
    }
    
    init(url u: URL, walletManager wm: WalletManager) {
        walletManager = wm
        url = u
    }
    
    func newNonce() -> String {
        let defs = UserDefaults.standard
        let nonceKey = "\(url.host!)/\(url.path)"
        var allNonces = [String: [String]]()
        var specificNonces = [String]()
        
        // load previous nonces. we save all nonces generated for each service
        // so they are not used twice from the same device
        if let existingNonces = defs.object(forKey: BRBitID.USER_DEFAULTS_NONCE_KEY) {
            allNonces = existingNonces as! [String: [String]]
        }
        if let existingSpecificNonces = allNonces[nonceKey] {
            specificNonces = existingSpecificNonces
        }
        
        // generate a completely new nonce
        var nonce: String
        repeat {
            nonce = "\(Int(Date().timeIntervalSince1970))"
        } while (specificNonces.contains(nonce))
        
        // save out the nonce list
        specificNonces.append(nonce)
        allNonces[nonceKey] = specificNonces
        defs.set(allNonces, forKey: BRBitID.USER_DEFAULTS_NONCE_KEY)
        
        return nonce
    }    
}
