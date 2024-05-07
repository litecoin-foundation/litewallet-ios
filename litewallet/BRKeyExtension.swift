//
//  BRKeyExtension.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/4/23.
//  Copyright © 2023 Litecoin Foundation. All rights reserved.
//
import BRCore
import Foundation

extension BRKey {
	// privKey must be wallet import format (WIF), mini private key format, or hex string
	init?(privKey: String) {
		self.init()
		guard BRKeySetPrivKey(&self, privKey) != 0 else { return nil }
	}

	// decrypts a BIP38 key using the given passphrase and returns nil if passphrase is incorrect
	init?(bip38Key: String, passphrase: String) {
		self.init()
		guard let nfcPhrase = CFStringCreateMutableCopy(secureAllocator, 0, passphrase as CFString) else { return nil }
		CFStringNormalize(nfcPhrase, .C) // NFC unicode normalization
		guard BRKeySetBIP38Key(&self, bip38Key, nfcPhrase as String) != 0 else { return nil }
	}

	// pubKey must be a DER encoded public key
	init?(pubKey: [UInt8]) {
		self.init()
		guard BRKeySetPubKey(&self, pubKey, pubKey.count) != 0 else { return nil }
	}

	init?(secret: UnsafePointer<UInt256>, compact: Bool) {
		self.init()
		guard BRKeySetSecret(&self, secret, compact ? 1 : 0) != 0 else { return nil }
	}

	// recover a pubKey from a compact signature
	init?(md: UInt256, compactSig: [UInt8]) {
		self.init()
		guard BRKeyRecoverPubKey(&self, md, compactSig, compactSig.count) != 0 else { return nil }
	}

	// WIF private key
	mutating func privKey() -> String? {
		return autoreleasepool { // wrapping in autoreleasepool ensures sensitive memory is wiped and freed immediately
			let count = BRKeyPrivKey(&self, nil, 0)
			var data = CFDataCreateMutable(secureAllocator, count) as Data
			data.count = count
			guard data.withUnsafeMutableBytes({ BRKeyPrivKey(&self, $0, count) }) != 0 else { return nil }
			return CFStringCreateFromExternalRepresentation(secureAllocator, data as CFData,
			                                                CFStringBuiltInEncodings.UTF8.rawValue) as String
		}
	}

	// encrypts key with passphrase
	mutating func bip38Key(passphrase: String) -> String? {
		return autoreleasepool {
			guard let nfcPhrase = CFStringCreateMutableCopy(secureAllocator, 0, passphrase as CFString)
			else { return nil }
			CFStringNormalize(nfcPhrase, .C) // NFC unicode normalization
			let count = BRKeyBIP38Key(&self, nil, 0, nfcPhrase as String)
			var data = CFDataCreateMutable(secureAllocator, count) as Data
			data.count = count
			guard data.withUnsafeMutableBytes({ BRKeyBIP38Key(&self, $0, count, nfcPhrase as String) }) != 0
			else { return nil }
			return CFStringCreateFromExternalRepresentation(secureAllocator, data as CFData,
			                                                CFStringBuiltInEncodings.UTF8.rawValue) as String
		}
	}

	// DER encoded public key
	mutating func pubKey() -> [UInt8]? {
		var pubKey = [UInt8](repeating: 0, count: BRKeyPubKey(&self, nil, 0))
		guard !pubKey.isEmpty, BRKeyPubKey(&self, &pubKey, pubKey.count) == pubKey.count else { return nil }
		return pubKey
	}

	// ripemd160 hash of the sha256 hash of the public key
	mutating func hash160() -> UInt160? {
		let hash = BRKeyHash160(&self)
		guard hash != UInt160() else { return nil }
		return hash
	}

	// pay-to-pubkey-hash litecoin address
	mutating func address() -> String? {
		var addr = [CChar](repeating: 0, count: MemoryLayout<BRAddress>.size)
		guard BRKeyAddress(&self, &addr, addr.count) > 0 else { return nil }
		return String(cString: addr)
	}

	mutating func sign(md: UInt256) -> [UInt8]? {
		var sig = [UInt8](repeating: 0, count: 73)
		let count = BRKeySign(&self, &sig, sig.count, md)
		guard count > 0 else { return nil }
		if count < sig.count { sig.removeSubrange(sig.count...) }
		return sig
	}

	mutating func verify(md: UInt256, sig: [UInt8]) -> Bool {
		var sig = sig
		return BRKeyVerify(&self, md, &sig, sig.count) != 0
	}

	// wipes key material
	mutating func clean() {
		BRKeyClean(&self)
	}

	// Pieter Wuille's compact signature encoding used for bitcoin message signing
	// to verify a compact signature, recover a public key from the sig and verify that it matches the signer's pubkey
	mutating func compactSign(md: UInt256) -> [UInt8]? {
		var sig = [UInt8](repeating: 0, count: 65)
		guard BRKeyCompactSign(&self, &sig, sig.count, md) == sig.count else { return nil }
		return sig
	}
}
