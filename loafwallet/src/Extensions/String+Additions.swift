//
//  String+Additions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-12-12.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit
import Foundation
import BRCore
import FirebaseAnalytics
 
extension String {
    
    var isValidPrivateKey: Bool {
        return BRPrivKeyIsValid(self) != 0
    }

    var isValidBip38Key: Bool {
        return BRBIP38KeyIsValid(self) != 0
    }
    
    var isValidAddress: Bool {
        guard lengthOfBytes(using: .utf8) > 0 else { return false }
        return BRAddressIsValid(self) != 0
    }
    
    var sanitized: String {
        return applyingTransform(.toUnicodeName, reverse: false) ?? ""
    }

    func ltrim(_ chars: Set<Character>) -> String {
        if let index = self.index(where: {!chars.contains($0)}) {
            return String(self[index..<self.endIndex])
        } else {
            return ""
        }
    }
    
    func rtrim(_ chars: Set<Character>) -> String {
        if let index = self.reversed().index(where: {!chars.contains($0)}) {
            return String(self[self.startIndex...self.index(before: index.base)])
        } else {
            return ""
        }
    }

    func nsRange(from range: Range<Index>) -> NSRange {
        let location = utf16.distance(from: utf16.startIndex, to: range.lowerBound)
        let length = utf16.distance(from: range.lowerBound, to: range.upperBound)
        return NSRange(location: location, length: length)
    }
}

private let startTag = "<b>"
private let endTag = "</b>"

//Convert string with <b> tags to attributed string
extension String {
    var tagsRemoved: String {
        return replacingOccurrences(of: startTag, with: "").replacingOccurrences(of: endTag, with: "")
    }

    var attributedStringForTags: NSAttributedString {
        let output = NSMutableAttributedString()
        let scanner = Scanner(string: self)
        let endCount = tagsRemoved.utf8.count
        var i = 0
        while output.string.utf8.count < endCount || i < 50 {
            var regular: NSString?
            var bold: NSString?
            scanner.scanUpTo(startTag, into: &regular)
            scanner.scanUpTo(endTag, into: &bold)
            if let regular = regular {
                output.append(NSAttributedString(string: (regular as String).tagsRemoved, attributes: UIFont.regularAttributes))
            }
            if let bold = bold {
                output.append(NSAttributedString(string: (bold as String).tagsRemoved, attributes: UIFont.boldAttributes))
            }
            i += 1
        }
        return output
    }
}

// MARK: - Hex String conversions
extension String {
    var hexToData: Data? {
        let scalars = unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            guard var nibble = scalar.nibble else { return nil }
            if index & 1 == 0 {
                nibble <<= 4
            }
            bytes[index >> 1] |= nibble
        }
        return Data(bytes: bytes)
    }
}

extension UnicodeScalar {
    var nibble: UInt8? {
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        }
        else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        }
        else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        return nil
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func replacingZeroFeeWithOneCent() -> String {
       
        guard self.count > 3 else {
            LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["ERROR":"STRING_ISSUE"])
            return self
        }
        
        let range = self.index(self.endIndex, offsetBy: -3)..<self.endIndex
        return self.replacingOccurrences(of: ".00", with: ".01", options: .literal, range: range)
    }
    
    func combinedFeeReplacingZeroFeeWithOneCent() -> String {
        
        guard self.count > 4 else {
            LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR, properties: ["ERROR":"STRING_ISSUE"])
            return self
        }
        
        let range = self.index(self.endIndex, offsetBy: -4)..<self.endIndex
        return self.replacingOccurrences(of: ".00)", with: ".01)", options: .literal, range: range)
    }
}
