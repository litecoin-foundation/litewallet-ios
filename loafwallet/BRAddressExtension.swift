//
//  BRAddressExtension.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/4/23.
//  Copyright © 2023 Litecoin Foundation. All rights reserved.
//
import BRCore
import Foundation

extension BRAddress: CustomStringConvertible, Hashable {
	init?(string: String) {
		self.init()
		let cStr = [CChar](string.utf8CString)
		guard cStr.count <= MemoryLayout<BRAddress>.size else { return nil }
		UnsafeMutableRawPointer(mutating: &s).assumingMemoryBound(to: CChar.self).assign(from: cStr,
		                                                                                 count: cStr.count)
	}

	init?(scriptPubKey: [UInt8]) {
		self.init()
		guard BRAddressFromScriptPubKey(UnsafeMutableRawPointer(mutating: &s).assumingMemoryBound(to: CChar.self),
		                                MemoryLayout<BRAddress>.size, scriptPubKey, scriptPubKey.count) > 0
		else { return nil }
	}

	init?(scriptSig: [UInt8]) {
		self.init()
		guard BRAddressFromScriptSig(UnsafeMutableRawPointer(mutating: &s).assumingMemoryBound(to: CChar.self),
		                             MemoryLayout<BRAddress>.size, scriptSig, scriptSig.count) > 0 else { return nil }
	}

	var scriptPubKey: [UInt8]? {
		var script = [UInt8](repeating: 0, count: 25)
		let count = BRAddressScriptPubKey(&script, script.count,
		                                  UnsafeRawPointer([s]).assumingMemoryBound(to: CChar.self))
		guard count > 0 else { return nil }
		if count < script.count { script.removeSubrange(count...) }
		return script
	}

	var hash160: UInt160? {
		var hash = UInt160()
		guard BRAddressHash160(&hash, UnsafeRawPointer([s]).assumingMemoryBound(to: CChar.self)) != 0
		else { return nil }
		return hash
	}

	public var description: String {
		return String(cString: UnsafeRawPointer([s]).assumingMemoryBound(to: CChar.self))
	}

	public var hashValue: Int {
		return BRAddressHash([s])
	}

	public static func == (l: BRAddress, r: BRAddress) -> Bool {
		return BRAddressEq([l.s], [r.s]) != 0
	}
}
