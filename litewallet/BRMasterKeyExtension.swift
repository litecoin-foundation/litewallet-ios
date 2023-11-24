import BRCore
import Foundation

extension BRMasterPubKey: Equatable {
	public static func == (l: BRMasterPubKey, r: BRMasterPubKey) -> Bool {
		return l.fingerPrint == r.fingerPrint && l.chainCode == r.chainCode && l.pubKey == r.pubKey
	}

	public static func != (l: BRMasterPubKey, r: BRMasterPubKey) -> Bool {
		return l.fingerPrint != r.fingerPrint || l.chainCode != r.chainCode || l.pubKey != r.pubKey
	}
}
