import Foundation
import XCTest

func clearKeychain() {
	let classes = [kSecClassGenericPassword as String,
	               kSecClassInternetPassword as String,
	               kSecClassCertificate as String,
	               kSecClassKey as String,
	               kSecClassIdentity as String]
	classes.forEach { className in
		SecItemDelete([kSecClass as String: className] as CFDictionary)
	}
}

func deleteDb() {
	let fm = FileManager.default
	let docsUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
	let url = docsUrl.appendingPathComponent("kvstore.sqlite3")
	if fm.fileExists(atPath: url.path) {
		do {
			try fm.removeItem(at: url)
		} catch {
			XCTFail("Could not delete kv store data: \(error)")
		}
	}
}
