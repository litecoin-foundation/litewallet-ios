import Foundation
import SwiftUI
import UIKit

enum CreateStepConfig {
	case intro
	case checkboxes
	case seedPhrase
	case finished

	var backgroundColor: Color {
		switch self {
		case .intro:
			return .litewalletLightGray
		case .checkboxes:
			return .litewalletOrange
		case .seedPhrase:
			return .litewalletGreen
		case .finished:
			return .liteWalletDarkBlue
		}
	}

	var mainTitle: String {
		switch self {
		case .intro:
			return "Introduction to Litewallet"
		case .checkboxes:
			return "Join the Community"
		case .seedPhrase:
			return "Don't lose this!"
		case .finished:
			return "Check out your Litewallet"
		}
	}

	var detailMessage: String {
		switch self {
		case .intro:
			return "You will need 5 mins, a private area and way to take this information down."
		case .checkboxes:
			return "You will need 5 mins, a private area and way to take this information down."
		case .seedPhrase:
			return "You will need 5 mins, a private area and way to take this information down."
		case .finished:
			return "You will need 5 mins, a private area and way to take this information down."
		}
	}

	var extendedMessage: String {
		switch self {
		case .intro:
			return "You will need 5 mins, a private area and way to take this information down."
		case .checkboxes:
			return "You will need 5 mins, a private area and way to take this information down."
		case .seedPhrase:
			return "You will need 5 mins, a private area and way to take this information down."
		case .finished:
			return "You will need 5 mins, a private area and way to take this information down."
		}
	}

	var bullet1: String {
		switch self {
		case .intro:
			return "You will need 5 mins, a private area and way to take this information down."
		case .checkboxes:
			return "You will need 5 mins, a private area and way to take this information down."
		case .seedPhrase:
			return "You will need 5 mins, a private area and way to take this information down."
		case .finished:
			return "You will need 5 mins, a private area and way to take this information down."
		}
	}

	var bullet2: String {
		switch self {
		case .intro:
			return "You will need 5 mins, a private area and way to take this information down."
		case .checkboxes:
			return "You will need 5 mins, a private area and way to take this information down."
		case .seedPhrase:
			return "You will need 5 mins, a private area and way to take this information down."
		case .finished:
			return "You will need 5 mins, a private area and way to take this information down."
		}
	}

	var bullet3: String {
		switch self {
		case .intro:
			return "You will need 5 mins, a private area and way to take this information down."
		case .checkboxes:
			return "You will need 5 mins, a private area and way to take this information down."
		case .seedPhrase:
			return "You will need 5 mins, a private area and way to take this information down."
		case .finished:
			return "You will need 5 mins, a private area and way to take this information down."
		}
	}
}
