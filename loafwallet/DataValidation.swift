//
//  DataValidation.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/28/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation

enum ValidatorType {
    case email
    case genericString
    case password
    case mobileNumber
    case requiredField(field: String)
}
 
protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

struct ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
            case .genericString: return GenericStringValidator()
            case .email: return EmailValidator()
            case .password: return PasswordValidator()
            case .mobileNumber: return MobileNumberValidator()
            case let .requiredField(fieldName): return RequiredFieldValidator(fieldName)
        }
    }
}
 
struct GenericStringValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        
        guard !value.isEmpty else { throw ValidationError(S.LitecoinCard
                                                            .Registration
                                                            .ValidationError
                                                            .empty.localize()) }
        return value
    }
}

struct MobileNumberValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        
        guard value != "" else { throw ValidationError(S.LitecoinCard
                                                        .Registration
                                                        .ValidationError
                                                        .empty.localize()) }
        
        guard value.count >= 10 else { throw ValidationError(S.LitecoinCard
                                                                .Registration
                                                                .ValidationError
                                                                .numberDigitsRequired.localize()) }
        return value
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError(S.LitecoinCard
                                    .Registration
                                    .ValidationError
                                    .requiredField.localize() + fieldName)
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        
        guard value != "" else { throw ValidationError(S.LitecoinCard
                                                        .Registration
                                                        .ValidationError
                                                        .empty.localize()) }
        
        guard value.count >= 6 else { throw ValidationError(S.LitecoinCard
                                                                .Registration
                                                                .ValidationError
                                                                .passwordCharacters.localize()) }
        
        do {
            if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(S.LitecoinCard
                                        .Registration
                                        .ValidationError
                                        .passwordComposition.localize())
            }
        } catch {
            throw  ValidationError(S.LitecoinCard
                                    .Registration
                                    .ValidationError
                                    .passwordComposition.localize())
        }
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(S.LitecoinCard
                                    .Registration
                                    .ValidationError
                                    .invalidEmail.localize())
            }
        } catch {
            throw ValidationError(S.LitecoinCard
                                    .Registration
                                    .ValidationError
                                    .invalidEmail.localize())
        }
        return value
    }
}
