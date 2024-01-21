import BRCore
import Foundation

extension BRTxOutput {
	var swiftAddress: String {
		get {
			return
				String(cString: UnsafeRawPointer([address]).assumingMemoryBound(to: CChar.self))
		}
		set { BRTxOutputSetAddress(&self, newValue) }
	}

	var updatedSwiftAddress: String {
		get {
			return charInt8ToString(charArray: address)
		}
		set { BRTxOutputSetAddress(&self, newValue) }
	}

	var swiftScript: [UInt8] {
		get { return [UInt8](UnsafeBufferPointer(start: script, count: scriptLen)) }
		set { BRTxOutputSetScript(&self, newValue, newValue.count) }
	}
}
