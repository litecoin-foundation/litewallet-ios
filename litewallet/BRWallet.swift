import BRCore
import Foundation

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
		return charInt8ToString(charArray: BRWalletReceiveAddress(cPtr).s)
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

	// returns an unsigned transaction that sends the specified amount from the wallet to the given address
	func createOpsTransaction(forAmount: UInt64, toAddress: String, opsFee: UInt64, opsAddress: String) -> BRTxRef? {
		return BRWalletCreateOpsTransaction(cPtr, forAmount, toAddress, opsFee, opsAddress)
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
