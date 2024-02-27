import BRCore
import Foundation

typealias BRTxRef = UnsafeMutablePointer<BRTransaction>
typealias BRBlockRef = UnsafeMutablePointer<BRMerkleBlock>

/// BRPeerManagerError: Error
enum BRPeerManagerError: Error {
	case posixError(errorCode: Int32, description: String)
}

// MARK: - BRCore Protocols

protocol BRWalletListener {
	func balanceChanged(_ balance: UInt64)
	func txAdded(_ tx: BRTxRef)
	func txUpdated(_ txHashes: [UInt256], blockHeight: UInt32, timestamp: UInt32)
	func txDeleted(_ txHash: UInt256, notifyUser: Bool, recommendRescan: Bool)
}

protocol BRPeerManagerListener {
	func syncStarted()
	func syncStopped(_ error: BRPeerManagerError?)
	func txStatusUpdate()
	func saveBlocks(_ replace: Bool, _ blocks: [BRBlockRef?])
	func savePeers(_ replace: Bool, _ peers: [BRPeer])
	func networkIsReachable() -> Bool
}

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
/// - Parameter characterArray: [CChar]
/// - Returns: String
public func charInt8ToString(charArray: (CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar)) -> String {
	let addressCharArray = [unichar(charArray.0), unichar(charArray.1), unichar(charArray.2), unichar(charArray.3), unichar(charArray.4),
	                        unichar(charArray.5), unichar(charArray.6), unichar(charArray.7), unichar(charArray.8), unichar(charArray.9),
	                        unichar(charArray.10), unichar(charArray.11), unichar(charArray.12), unichar(charArray.13), unichar(charArray.14),
	                        unichar(charArray.15), unichar(charArray.16), unichar(charArray.17), unichar(charArray.18), unichar(charArray.19),
	                        unichar(charArray.20), unichar(charArray.21), unichar(charArray.22), unichar(charArray.23), unichar(charArray.24),
	                        unichar(charArray.25), unichar(charArray.26), unichar(charArray.27), unichar(charArray.28), unichar(charArray.29),
	                        unichar(charArray.30), unichar(charArray.31), unichar(charArray.32), unichar(charArray.33), unichar(charArray.34),
	                        unichar(charArray.35), unichar(charArray.36), unichar(charArray.37), unichar(charArray.38), unichar(charArray.39),
	                        unichar(charArray.40), unichar(charArray.41), unichar(charArray.42), unichar(charArray.43), unichar(charArray.44),
	                        unichar(charArray.45), unichar(charArray.46), unichar(charArray.47), unichar(charArray.48), unichar(charArray.49),
	                        unichar(charArray.50), unichar(charArray.51), unichar(charArray.52), unichar(charArray.53), unichar(charArray.54),
	                        unichar(charArray.55), unichar(charArray.56), unichar(charArray.57), unichar(charArray.58), unichar(charArray.59),
	                        unichar(charArray.60), unichar(charArray.61), unichar(charArray.62), unichar(charArray.63), unichar(charArray.64),
	                        unichar(charArray.65), unichar(charArray.66), unichar(charArray.67), unichar(charArray.68), unichar(charArray.69),
	                        unichar(charArray.70), unichar(charArray.71), unichar(charArray.72), unichar(charArray.73), unichar(charArray.74)]

	let length = addressCharArray.reduce(0) { $1 != 0 ? $0 + 1 : $0 }
	return String(NSString(characters: addressCharArray, length: length))
}

/// Converts String to CChar
/// - Parameter String
/// - Returns: characterArray: [CChar]
public func stringToCharArray(addressString: String) -> [CChar] {
	let arrayLength = 75

	var charArray = [CChar]()

	let stringArray = Array(addressString)

	for index in 0 ... arrayLength - 1 {
		if index < stringArray.count {
			let value = Int8(stringArray[index]
				.unicodeScalars
				.map { $0.value }.reduce(0, +))
			charArray.append(CChar(value))
		} else {
			charArray.append(0)
		}
	}

	return charArray
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
