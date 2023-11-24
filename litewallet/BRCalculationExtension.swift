import BRCore
import Foundation

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
