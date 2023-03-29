import BRCore
import Foundation

typealias BRTxRef = UnsafeMutablePointer<BRTransaction>
typealias BRBlockRef = UnsafeMutablePointer<BRMerkleBlock>

private func secureAllocate(allocSize: CFIndex, hint _: CFOptionFlags, info _: UnsafeMutableRawPointer?)
	-> UnsafeMutableRawPointer?
{
	guard let ptr = malloc(MemoryLayout<CFIndex>.stride + allocSize) else { return nil }
	// keep track of the size of the allocation so it can be cleansed before deallocation
	ptr.storeBytes(of: allocSize, as: CFIndex.self)
	return ptr.advanced(by: MemoryLayout<CFIndex>.stride)
}

private func secureDeallocate(ptr: UnsafeMutableRawPointer?, info _: UnsafeMutableRawPointer?) {
	guard let ptr = ptr else { return }
	let allocSize = ptr.load(fromByteOffset: -MemoryLayout<CFIndex>.stride, as: CFIndex.self)
	memset(ptr, 0, allocSize) // cleanse allocated memory
	free(ptr.advanced(by: -MemoryLayout<CFIndex>.stride))
}

private func secureReallocate(ptr: UnsafeMutableRawPointer?, newsize: CFIndex, hint: CFOptionFlags,
                              info: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
{
	// there's no way to tell ahead of time if the original memory will be deallocted even if the new size is smaller
	// than the old size, so just cleanse and deallocate every time
	guard let ptr = ptr else { return nil }
	let newptr = secureAllocate(allocSize: newsize, hint: hint, info: info)
	let allocSize = ptr.load(fromByteOffset: -MemoryLayout<CFIndex>.stride, as: CFIndex.self)
	if newptr != nil { memcpy(newptr, ptr, (allocSize < newsize) ? allocSize : newsize) }
	secureDeallocate(ptr: ptr, info: info)
	return newptr
}

/// Converts CChar to Int8 and String
/// - Parameter tuple: CChar
/// - Returns: String
private func charInt8ToString(tuple: (CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar)) -> String {
	var tuplesArray = [unichar(tuple.0), unichar(tuple.1), unichar(tuple.2), unichar(tuple.3),
	                   unichar(tuple.4), unichar(tuple.5), unichar(tuple.6), unichar(tuple.7),
	                   unichar(tuple.8), unichar(tuple.9), unichar(tuple.10), unichar(tuple.11),
	                   unichar(tuple.12), unichar(tuple.13), unichar(tuple.14), unichar(tuple.15),
	                   unichar(tuple.16), unichar(tuple.17), unichar(tuple.18), unichar(tuple.19),
	                   unichar(tuple.20), unichar(tuple.21), unichar(tuple.22), unichar(tuple.23),
	                   unichar(tuple.23), unichar(tuple.24), unichar(tuple.25), unichar(tuple.26),
	                   unichar(tuple.27), unichar(tuple.28), unichar(tuple.29), unichar(tuple.30),
	                   unichar(tuple.31), unichar(tuple.32), unichar(tuple.33), unichar(tuple.34),
	                   unichar(tuple.35), unichar(tuple.36), unichar(tuple.37), unichar(tuple.38),
	                   unichar(tuple.39), unichar(tuple.40), unichar(tuple.41), unichar(tuple.42),
	                   unichar(tuple.43), unichar(tuple.44), unichar(tuple.45), unichar(tuple.46),
	                   unichar(tuple.47), unichar(tuple.48), unichar(tuple.49), unichar(tuple.50),
	                   unichar(tuple.51), unichar(tuple.52), unichar(tuple.53), unichar(tuple.54),
	                   unichar(tuple.55), unichar(tuple.56), unichar(tuple.57), unichar(tuple.58),
	                   unichar(tuple.59), unichar(tuple.60), unichar(tuple.61), unichar(tuple.62),
	                   unichar(tuple.63), unichar(tuple.64), unichar(tuple.65), unichar(tuple.66),
	                   unichar(tuple.67), unichar(tuple.68), unichar(tuple.69), unichar(tuple.70),
	                   unichar(tuple.71), unichar(tuple.72), unichar(tuple.73), unichar(tuple.74)]

	let length = tuplesArray.reduce(0) { $1 != 0 ? $0 + 1 : $0 }
	return String(NSString(characters: tuplesArray, length: length))
}

// since iOS does not page memory to disk, all we need to do is cleanse allocated memory prior to deallocation
public let secureAllocator: CFAllocator = {
	var context = CFAllocatorContext()
	context.version = 0
	CFAllocatorGetContext(kCFAllocatorDefault, &context)
	context.allocate = secureAllocate
	context.reallocate = secureReallocate
	context.deallocate = secureDeallocate
	return CFAllocatorCreate(kCFAllocatorDefault, &context).takeRetainedValue()
}()

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
		return autoreleasepool
			{ // wrapping in autoreleasepool ensures sensitive memory is wiped and freed immediately
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

	// pay-to-pubkey-hash bitcoin address
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

extension BRTxInput {
	var swiftAddress: String {
		get { return String(cString: UnsafeRawPointer([address]).assumingMemoryBound(to: CChar.self)) }
		set { BRTxInputSetAddress(&self, newValue) }
	}

	var updatedSwiftAddress: String {
		get {
			print(":::Receved: \(charInt8ToString(tuple: address))")
			return charInt8ToString(tuple: address)
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

extension BRTxOutput {
	var swiftAddress: String {
		get { return String(cString: UnsafeRawPointer([address]).assumingMemoryBound(to: CChar.self)) }
		set { BRTxOutputSetAddress(&self, newValue) }
	}

	var updatedSwiftAddress: String {
		get {
			print(":::Output: \(charInt8ToString(tuple: address))")

			return charInt8ToString(tuple: address)
		}
		set { BRTxOutputSetAddress(&self, newValue) }
	}

	var swiftScript: [UInt8] {
		get { return [UInt8](UnsafeBufferPointer(start: script, count: scriptLen)) }
		set { BRTxOutputSetScript(&self, newValue, newValue.count) }
	}
}

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

protocol BRWalletListener {
	func balanceChanged(_ balance: UInt64)
	func txAdded(_ tx: BRTxRef)
	func txUpdated(_ txHashes: [UInt256], blockHeight: UInt32, timestamp: UInt32)
	func txDeleted(_ txHash: UInt256, notifyUser: Bool, recommendRescan: Bool)
}

class BRWallet {
	let cPtr: OpaquePointer
	let listener: BRWalletListener

	init?(transactions: [BRTxRef?], masterPubKey: BRMasterPubKey, listener: BRWalletListener) {
		var txRefs = transactions
		guard let cPtr = BRWalletNew(&txRefs, txRefs.count, masterPubKey) else { return nil }
		self.listener = listener
		self.cPtr = cPtr

		BRWalletSetCallbacks(cPtr, Unmanaged.passUnretained(self).toOpaque(),
		                     { info, balance in // balanceChanged
		                     	guard let info = info else { return }
		                     	Unmanaged<BRWallet>.fromOpaque(info).takeUnretainedValue().listener.balanceChanged(balance)
		                     },
		                     { info, tx in // txAdded
		                     	guard let info = info, let tx = tx else { return }
		                     	Unmanaged<BRWallet>.fromOpaque(info).takeUnretainedValue().listener.txAdded(tx)
		                     },
		                     { info, txHashes, txCount, blockHeight, timestamp in // txUpdated
		                     	guard let info = info else { return }
		                     	let hashes = [UInt256](UnsafeBufferPointer(start: txHashes, count: txCount))
		                     	Unmanaged<BRWallet>.fromOpaque(info).takeUnretainedValue().listener.txUpdated(hashes,
		                     	                                                                              blockHeight: blockHeight,
		                     	                                                                              timestamp: timestamp)
		                     },
		                     { info, txHash, notify, rescan in // txDeleted
		                     	guard let info = info else { return }
		                     	Unmanaged<BRWallet>.fromOpaque(info).takeUnretainedValue().listener.txDeleted(txHash,
		                     	                                                                              notifyUser: notify != 0,
		                     	                                                                              recommendRescan: rescan != 0)
		                     })
	}

	// the first unused external address
	var receiveAddress: String {
		return BRWalletReceiveAddress(cPtr).description
	}

	// all previously genereated internal and external addresses
	var allAddresses: [String] {
		var addrs = [BRAddress](repeating: BRAddress(), count: BRWalletAllAddrs(cPtr, nil, 0))
		guard BRWalletAllAddrs(cPtr, &addrs, addrs.count) == addrs.count else { return [] }
		return addrs.map { $0.description }
	}

	// true if the address is a previously generated internal or external address
	func containsAddress(_ address: String) -> Bool {
		return BRWalletContainsAddress(cPtr, address) != 0
	}

	func addressIsUsed(_ address: String) -> Bool {
		return BRWalletAddressIsUsed(cPtr, address) != 0
	}

	// transactions registered in the wallet, sorted by date, oldest first
	var transactions: [BRTxRef?] {
		var transactions = [BRTxRef?](repeating: nil, count: BRWalletTransactions(cPtr, nil, 0))
		guard BRWalletTransactions(cPtr, &transactions, transactions.count) == transactions.count else { return [] }
		return transactions
	}

	// current wallet balance, not including transactions known to be invalid
	var balance: UInt64 {
		return BRWalletBalance(cPtr)
	}

	// total amount spent from the wallet (exluding change)
	var totalSent: UInt64 {
		return BRWalletTotalSent(cPtr)
	}

	// fee-per-kb of transaction size to use when creating a transaction
	var feePerKb: UInt64 {
		get { return BRWalletFeePerKb(cPtr) }
		set(value) { BRWalletSetFeePerKb(cPtr, value) }
	}

	func feeForTx(amount: UInt64) -> UInt64 {
		return BRWalletFeeForTxAmount(cPtr, amount)
	}

	// returns an unsigned transaction that sends the specified amount from the wallet to the given address
	func createTransaction(forAmount: UInt64, toAddress: String) -> BRTxRef? {
		return BRWalletCreateTransaction(cPtr, forAmount, toAddress)
	}

	// returns an unsigned transaction that satisifes the given transaction outputs
	func createTxForOutputs(_ outputs: [BRTxOutput]) -> BRTxRef {
		return BRWalletCreateTxForOutputs(cPtr, outputs, outputs.count)
	}

	// signs any inputs in tx that can be signed using private keys from the wallet
	// forkId is 0 for bitcoin, 0x40 for b-cash
	// seed is the master private key (wallet seed) corresponding to the master public key given when wallet was created
	// returns true if all inputs were signed, or false if there was an error or not all inputs were able to be signed
	func signTransaction(_ tx: BRTxRef, forkId: Int = 0, seed: inout UInt512) -> Bool {
		return BRWalletSignTransaction(cPtr, tx, Int32(forkId), &seed, MemoryLayout<UInt512>.stride) != 0
	}

	// true if no previous wallet transaction spends any of the given transaction's inputs, and no inputs are invalid
	func transactionIsValid(_ tx: BRTxRef) -> Bool {
		return BRWalletTransactionIsValid(cPtr, tx) != 0
	}

	// true if transaction cannot be immediately spent (i.e. if it or an input tx can be replaced-by-fee)
	func transactionIsPending(_ tx: BRTxRef) -> Bool {
		return BRWalletTransactionIsPending(cPtr, tx) != 0
	}

	// true if tx is considered 0-conf safe (valid and not pending, timestamp greater than 0, and no unverified inputs)
	func transactionIsVerified(_ tx: BRTxRef) -> Bool {
		return BRWalletTransactionIsVerified(cPtr, tx) != 0
	}

	// the amount received by the wallet from the transaction (total outputs to change and/or receive addresses)
	func amountReceivedFromTx(_ tx: BRTxRef) -> UInt64 {
		return BRWalletAmountReceivedFromTx(cPtr, tx)
	}

	// the amount sent from the wallet by the trasaction (total wallet outputs consumed, change and fee included)
	func amountSentByTx(_ tx: BRTxRef) -> UInt64 {
		return BRWalletAmountSentByTx(cPtr, tx)
	}

	// returns the fee for the given transaction if all its inputs are from wallet transactions
	func feeForTx(_ tx: BRTxRef) -> UInt64? {
		let fee = BRWalletFeeForTx(cPtr, tx)
		return fee == UINT64_MAX ? nil : fee
	}

	// historical wallet balance after the given transaction, or current balance if tx is not registered in wallet
	func balanceAfterTx(_ tx: BRTxRef) -> UInt64 {
		return BRWalletBalanceAfterTx(cPtr, tx)
	}

	// fee that will be added for a transaction of the given size in bytes
	func feeForTxSize(_ size: Int) -> UInt64 {
		return BRWalletFeeForTxSize(cPtr, size)
	}

	// outputs below this amount are uneconomical due to fees (TX_MIN_OUTPUT_AMOUNT is the absolute min output amount)
	var minOutputAmount: UInt64 {
		return BRWalletMinOutputAmount(cPtr)
	}

	// maximum amount that can be sent from the wallet to a single address after fees
	var maxOutputAmount: UInt64 {
		return BRWalletMaxOutputAmount(cPtr)
	}

	deinit {
		BRWalletFree(cPtr)
	}
}

enum BRPeerManagerError: Error {
	case posixError(errorCode: Int32, description: String)
}

protocol BRPeerManagerListener {
	func syncStarted()
	func syncStopped(_ error: BRPeerManagerError?)
	func txStatusUpdate()
	func saveBlocks(_ replace: Bool, _ blocks: [BRBlockRef?])
	func savePeers(_ replace: Bool, _ peers: [BRPeer])
	func networkIsReachable() -> Bool
}

class BRPeerManager {
	let cPtr: OpaquePointer
	let listener: BRPeerManagerListener
	let mainNetParams = [BRMainNetParams]

	init?(wallet: BRWallet, earliestKeyTime: TimeInterval, blocks: [BRBlockRef?], peers: [BRPeer],
	      listener: BRPeerManagerListener, falsePositivesRate: Double)
	{
		var blockRefs = blocks
		guard let cPtr = BRPeerManagerNew(mainNetParams, wallet.cPtr, UInt32(earliestKeyTime + NSTimeIntervalSince1970),
		                                  &blockRefs, blockRefs.count, peers, peers.count, falsePositivesRate) else { return nil }
		self.listener = listener
		self.cPtr = cPtr

		BRPeerManagerSetCallbacks(cPtr, Unmanaged.passUnretained(self).toOpaque(),
		                          { info in // syncStarted
		                          	guard let info = info else { return }
		                          	Unmanaged<BRPeerManager>.fromOpaque(info).takeUnretainedValue().listener.syncStarted()
		                          },
		                          { info, error in // syncStopped
		                          	guard let info = info else { return }
		                          	let err = BRPeerManagerError.posixError(errorCode: error, description: String(cString: strerror(error)))
		                          	Unmanaged<BRPeerManager>.fromOpaque(info).takeUnretainedValue().listener.syncStopped(error != 0 ? err : nil)
		                          },
		                          { info in // txStatusUpdate
		                          	guard let info = info else { return }
		                          	Unmanaged<BRPeerManager>.fromOpaque(info).takeUnretainedValue().listener.txStatusUpdate()
		                          },
		                          { info, replace, blocks, blocksCount in // saveBlocks
		                          	guard let info = info else { return }
		                          	let blockRefs = [BRBlockRef?](UnsafeBufferPointer(start: blocks, count: blocksCount))
		                          	Unmanaged<BRPeerManager>.fromOpaque(info).takeUnretainedValue().listener.saveBlocks(replace != 0, blockRefs)
		                          },
		                          { info, replace, peers, peersCount in // savePeers
		                          	guard let info = info else { return }
		                          	let peerList = [BRPeer](UnsafeBufferPointer(start: peers, count: peersCount))
		                          	Unmanaged<BRPeerManager>.fromOpaque(info).takeUnretainedValue().listener.savePeers(replace != 0, peerList)
		                          },
		                          { info -> Int32 in // networkIsReachable
		                          	guard let info = info else { return 0 }
		                          	return Unmanaged<BRPeerManager>.fromOpaque(info).takeUnretainedValue().listener.networkIsReachable() ? 1 : 0
		                          },
		                          nil) // threadCleanup
	}

	// true if currently connected to at least one peer
	var isConnected: Bool {
		return BRPeerManagerConnectStatus(cPtr) == BRPeerStatusConnected
	}

	// connect to bitcoin peer-to-peer network (also call this whenever networkIsReachable() status changes)
	func connect() {
		if let fixedAddress = UserDefaults.customNodeIP {
			setFixedPeer(address: fixedAddress, port: UserDefaults.customNodePort ?? C.standardPort)
		}
		BRPeerManagerConnect(cPtr)
	}

	// disconnect from bitcoin peer-to-peer network
	func disconnect() {
		BRPeerManagerDisconnect(cPtr)
	}

	// rescans blocks and transactions after earliestKeyTime (a new random download peer is also selected due to the
	// possibility that a malicious node might lie by omitting transactions that match the bloom filter)
	func rescan() {
		BRPeerManagerRescan(cPtr)
	}

	// current proof-of-work verified best block height
	var lastBlockHeight: UInt32 {
		return BRPeerManagerLastBlockHeight(cPtr)
	}

	// current proof-of-work verified best block timestamp (time interval since unix epoch)
	var lastBlockTimestamp: UInt32 {
		return BRPeerManagerLastBlockTimestamp(cPtr)
	}

	// the (unverified) best block height reported by connected peers
	var estimatedBlockHeight: UInt32 {
		return BRPeerManagerEstimatedBlockHeight(cPtr)
	}

	// Only show syncing view if more than 2 days behind
	var shouldShowSyncingView: Bool {
		let lastBlock = Date(timeIntervalSince1970: TimeInterval(lastBlockTimestamp))
		let cutoff = Date().addingTimeInterval(-24 * 60 * 60 * 2) // 2 days ago
		return lastBlock.compare(cutoff) == .orderedAscending
	}

	// current network sync progress from 0 to 1
	// startHeight is the block height of the most recent fully completed sync
	func syncProgress(fromStartHeight: UInt32) -> Double {
		return BRPeerManagerSyncProgress(cPtr, fromStartHeight)
	}

	// the number of currently connected peers
	var peerCount: Int {
		return BRPeerManagerPeerCount(cPtr)
	}

	// description of the peer most recently used to sync blockchain data
	var downloadPeerName: String {
		return String(cString: BRPeerManagerDownloadPeerName(cPtr))
	}

	// publishes tx to bitcoin network
	func publishTx(_ tx: BRTxRef, completion: @escaping (Bool, BRPeerManagerError?) -> Void) {
		BRPeerManagerPublishTx(cPtr, tx, Unmanaged.passRetained(CompletionWrapper(completion)).toOpaque())
			{ info, error in
				guard let info = info else { return }
				guard error == 0
				else {
					let err = BRPeerManagerError.posixError(errorCode: error, description: String(cString: strerror(error)))
					return Unmanaged<CompletionWrapper>.fromOpaque(info).takeRetainedValue().completion(false, err)
				}

				Unmanaged<CompletionWrapper>.fromOpaque(info).takeRetainedValue().completion(true, nil)
			}
	}

	// number of connected peers that have relayed the given unconfirmed transaction
	func relayCount(_ forTxHash: UInt256) -> Int {
		return BRPeerManagerRelayCount(cPtr, forTxHash)
	}

	func setFixedPeer(address: Int, port: Int) {
		if address != 0 {
			var newAddress = UInt128()
			newAddress.u16.5 = 0xFFFF
			newAddress.u32.3 = UInt32(address)
			BRPeerManagerSetFixedPeer(cPtr, newAddress, UInt16(port))
		} else {
			BRPeerManagerSetFixedPeer(cPtr, UInt128(), 0)
		}
	}

	deinit {
		BRPeerManagerDisconnect(cPtr)
		BRPeerManagerFree(cPtr)
	}

	private class CompletionWrapper {
		let completion: (Bool, BRPeerManagerError?) -> Void

		init(_ completion: @escaping (Bool, BRPeerManagerError?) -> Void) {
			self.completion = completion
		}
	}

	// hack to keep the swift compiler happy
	let a = BRMainNetDNSSeeds
	let b = BRMainNetCheckpoints
	let c = BRMainNetVerifyDifficulty
}

extension UInt256: CustomStringConvertible {
	public var description: String {
		return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x" +
			"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			u8.31, u8.30, u8.29, u8.28, u8.27, u8.26, u8.25, u8.24,
			u8.23, u8.22, u8.21, u8.20, u8.19, u8.18, u8.17, u8.16,
			u8.15, u8.14, u8.13, u8.12, u8.11, u8.10, u8.9, u8.8,
			u8.7, u8.6, u8.5, u8.4, u8.3, u8.2, u8.1, u8.0)
	}
}

extension UInt128: Equatable {
	public static func == (l: UInt128, r: UInt128) -> Bool {
		return l.u64 == r.u64
	}

	public static func != (l: UInt128, r: UInt128) -> Bool {
		return l.u64 != r.u64
	}
}

extension UInt160: Equatable {
	public static func == (l: UInt160, r: UInt160) -> Bool {
		return l.u32 == r.u32
	}

	public static func != (l: UInt160, r: UInt160) -> Bool {
		return l.u32 != r.u32
	}
}

extension UInt256: Equatable {
	public static func == (l: UInt256, r: UInt256) -> Bool {
		return l.u64 == r.u64
	}

	public static func != (l: UInt256, r: UInt256) -> Bool {
		return l.u64 != r.u64
	}

	var hexString: String {
		var u = self
		return withUnsafePointer(to: &u) { p in
			Data(bytes: p, count: MemoryLayout<UInt256>.stride).hexString
		}
	}
}

extension UInt512: Equatable {
	public static func == (l: UInt512, r: UInt512) -> Bool {
		return l.u64 == r.u64
	}

	public static func != (l: UInt512, r: UInt512) -> Bool {
		return l.u64 != r.u64
	}
}

extension BRMasterPubKey: Equatable {
	public static func == (l: BRMasterPubKey, r: BRMasterPubKey) -> Bool {
		return l.fingerPrint == r.fingerPrint && l.chainCode == r.chainCode && l.pubKey == r.pubKey
	}

	public static func != (l: BRMasterPubKey, r: BRMasterPubKey) -> Bool {
		return l.fingerPrint != r.fingerPrint || l.chainCode != r.chainCode || l.pubKey != r.pubKey
	}
}

// 8 element tuple equatable
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
	H: Equatable>(l: (A, B, C, D, E, F, G, H), r: (A, B, C, D, E, F, G, H)) -> Bool
{
	return l.0 == r.0 && l.1 == r.1 && l.2 == r.2 && l.3 == r.3 && l.4 == r.4 && l.5 == r.5 && l.6 == r.6 && l.7 == r.7
}

public func != <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
	H: Equatable>(l: (A, B, C, D, E, F, G, H), r: (A, B, C, D, E, F, G, H)) -> Bool
{
	return l.0 != r.0 || l.1 != r.1 || l.2 != r.2 || l.3 != r.3 || l.4 != r.4 || l.5 != r.5 || l.6 != r.6 || l.7 != r.7
}

// 33 element tuple equatable
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
	H: Equatable, I: Equatable, J: Equatable, K: Equatable, L: Equatable, M: Equatable, N: Equatable,
	O: Equatable, P: Equatable, Q: Equatable, R: Equatable, S: Equatable, T: Equatable, U: Equatable,
	V: Equatable, W: Equatable, X: Equatable, Y: Equatable, Z: Equatable, a: Equatable, b: Equatable,
	c: Equatable, d: Equatable, e: Equatable, f: Equatable, g: Equatable>
(l: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, b, c, d, e, f, g),
 r: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, b, c, d, e, f, g)) -> Bool
{
	return l.0 == r.0 && l.1 == r.1 && l.2 == r.2 && l.3 == r.3 && l.4 == r.4 && l.5 == r.5 && l.6 == r.6 &&
		l.7 == r.7 && l.8 == r.8 && l.9 == r.9 && l.10 == r.10 && l.11 == r.11 && l.12 == r.12 && l.13 == r.13 &&
		l.14 == r.14 && l.15 == r.15 && l.16 == r.16 && l.17 == r.17 && l.18 == r.18 && l.19 == r.19 && l.20 == r.20 &&
		l.21 == r.21 && l.22 == r.22 && l.23 == r.23 && l.24 == r.24 && l.25 == r.25 && l.26 == r.26 && l.27 == r.27 &&
		l.28 == r.28 && l.29 == r.29 && l.30 == r.30 && l.31 == r.31 && l.32 == r.32
}

public func != <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable,
	H: Equatable, I: Equatable, J: Equatable, K: Equatable, L: Equatable, M: Equatable, N: Equatable,
	O: Equatable, P: Equatable, Q: Equatable, R: Equatable, S: Equatable, T: Equatable, U: Equatable,
	V: Equatable, W: Equatable, X: Equatable, Y: Equatable, Z: Equatable, a: Equatable, b: Equatable,
	c: Equatable, d: Equatable, e: Equatable, f: Equatable, g: Equatable>
(l: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, b, c, d, e, f, g),
 r: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, b, c, d, e, f, g)) -> Bool
{
	return l.0 != r.0 || l.1 != r.1 || l.2 != r.2 || l.3 != r.3 || l.4 != r.4 || l.5 != r.5 || l.6 != r.6 ||
		l.7 != r.7 || l.8 != r.8 || l.9 != r.9 || l.10 != r.10 || l.11 != r.11 || l.12 != r.12 || l.13 != r.13 ||
		l.14 != r.14 || l.15 != r.15 || l.16 != r.16 || l.17 != r.17 || l.18 != r.18 || l.19 != r.19 || l.20 != r.20 ||
		l.21 != r.21 || l.22 != r.22 || l.23 != r.23 || l.24 != r.24 || l.25 != r.25 || l.26 != r.26 || l.27 != r.27 ||
		l.28 != r.28 || l.29 != r.29 || l.30 != r.30 || l.31 != r.31 || l.32 != r.32
}
