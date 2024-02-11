import BRCore
import Foundation

class BRPeerManager {
	let cPtr: OpaquePointer
	let listener: BRPeerManagerListener
	let mainNetParams = [BRMainNetParams]
	var falsePositiveRate: Double

	init?(wallet: BRWallet,
	      earliestKeyTime: TimeInterval,
	      blocks: [BRBlockRef?], peers: [BRPeer],
	      listener: BRPeerManagerListener,
	      fpRate: Double)
	{
		var blockRefs = blocks
		guard let cPtr = BRPeerManagerNew(mainNetParams, wallet.cPtr, UInt32(earliestKeyTime + NSTimeIntervalSince1970),
		                                  &blockRefs, blockRefs.count, peers, peers.count, fpRate) else { return nil }
		self.listener = listener
		self.cPtr = cPtr
		falsePositiveRate = fpRate

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

	// connect to litecoin peer-to-peer network (also call this whenever networkIsReachable() status changes)
	func connect() {
		if let fixedAddress = UserDefaults.customNodeIP {
			setFixedPeer(address: fixedAddress, port: UserDefaults.customNodePort ?? C.standardPort)
		}
		BRPeerManagerConnect(cPtr)
	}

	// disconnect from litecoin peer-to-peer network
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

	// publishes tx to litecoin network
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
