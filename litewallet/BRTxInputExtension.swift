import BRCore
import Foundation

extension BRTxInput {
	var swiftAddress: String {
		get { return String(cString: UnsafeRawPointer([address]).assumingMemoryBound(to: CChar.self)) }
		set { BRTxInputSetAddress(&self, newValue) }
	}

	var updatedSwiftAddress: String {
		get {
			return charInt8ToString(charArray: address)
		}
		set { BRTxInputSetAddress(&self, newValue) }
	}

	var swiftScript: [UInt8] {
		get { return [UInt8](UnsafeBufferPointer(start: script, count: scriptLen)) }
		set { BRTxInputSetScript(&self, newValue, newValue.count) }
	}

	var swiftSignature: [UInt8] {
		get { return [UInt8](UnsafeBufferPointer(start: signature, count: sigLen)) }
		set { BRTxInputSetSignature(&self, newValue, newValue.count) }
	}
}
