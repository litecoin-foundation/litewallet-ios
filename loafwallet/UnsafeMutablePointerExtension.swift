import BRCore
import Foundation

extension UnsafeMutablePointer where Pointee == BRTransaction {
	init?() {
		self.init(BRTransactionNew())
	}

	// bytes must contain a serialized tx
	init?(bytes: [UInt8]) {
		self.init(BRTransactionParse(bytes, bytes.count))
	}

	var txHash: UInt256 {
		return pointee.txHash
	}

	var version: UInt32 {
		return pointee.version
	}

	var inputs: [BRTxInput] {
		return [BRTxInput](UnsafeBufferPointer(start: pointee.inputs, count: pointee.inCount))
	}

	var outputs: [BRTxOutput] {
		return [BRTxOutput](UnsafeBufferPointer(start: pointee.outputs, count: pointee.outCount))
	}

	var lockTime: UInt32 {
		return pointee.lockTime
	}

	var blockHeight: UInt32 {
		get { return pointee.blockHeight }
		set { pointee.blockHeight = newValue }
	}

	var timestamp: TimeInterval {
		get { return pointee.timestamp > UInt32(NSTimeIntervalSince1970) ?
			TimeInterval(pointee.timestamp) - NSTimeIntervalSince1970 : 0
		}
		set { pointee.timestamp = newValue > 0 ? UInt32(newValue + NSTimeIntervalSince1970) : 0 }
	}

	// serialized transaction (blockHeight and timestamp are not serialized)
	var bytes: [UInt8]? {
		var bytes = [UInt8](repeating: 0, count: BRTransactionSerialize(self, nil, 0))
		guard BRTransactionSerialize(self, &bytes, bytes.count) == bytes.count else { return nil }
		return bytes
	}

	// adds an input to tx
	func addInput(txHash: UInt256, index: UInt32, amount: UInt64, script: [UInt8],
	              signature: [UInt8]? = nil, sequence: UInt32 = TXIN_SEQUENCE)
	{
		BRTransactionAddInput(self, txHash, index, amount, script, script.count, signature, signature?.count ?? 0, sequence)
	}

	// adds an output to tx
	func addOutput(amount: UInt64, script: [UInt8]) {
		BRTransactionAddOutput(self, amount, script, script.count)
	}

	// shuffles order of tx outputs
	func shuffleOutputs() {
		BRTransactionShuffleOutputs(self)
	}

	// size in bytes if signed, or estimated size assuming compact pubkey sigs
	var size: Int {
		return BRTransactionSize(self)
	}

	// minimum transaction fee needed for tx to relay across the bitcoin network
	var standardFee: UInt64 {
		return BRTransactionStandardFee(self)
	}

	// checks if all signatures exist, but does not verify them
	var isSigned: Bool {
		return BRTransactionIsSigned(self) != 0
	}

	// adds signatures to any inputs with NULL signatures that can be signed with any keys
	// forkId is 0 for bitcoin, 0x40 for b-cash
	// returns true if tx is signed
	func sign(forkId: Int = 0, keys: inout [BRKey]) -> Bool {
		return BRTransactionSign(self, Int32(forkId), &keys, keys.count) != 0
	}

	public var hashValue: Int {
		return BRTransactionHash(self)
	}

	public static func == (l: UnsafeMutablePointer<Pointee>, r: UnsafeMutablePointer<Pointee>) -> Bool
	{
		return BRTransactionEq(l, r) != 0
	}
}
