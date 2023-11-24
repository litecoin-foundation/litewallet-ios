import Foundation

enum TransactionDirection: String {
	case sent = "Sent"
	case received = "Received"
	case moved = "Moved"

	var amountFormat: String {
		switch self {
		case .sent:
			return S.TransactionDetails.sent.localize()
		case .received:
			return S.TransactionDetails.received.localize()
		case .moved:
			return S.TransactionDetails.moved.localize()
		}
	}

	var sign: String {
		switch self {
		case .sent:
			return "-"
		case .received:
			return ""
		case .moved:
			return ""
		}
	}

	var addressHeader: String {
		switch self {
		case .sent:
			return S.TransactionDirection.to.localize()
		case .received:
			return S.TransactionDirection.received.localize()
		case .moved:
			return S.TransactionDirection.to.localize()
		}
	}

	var amountDescriptionFormat: String {
		switch self {
		case .sent:
			return S.TransactionDetails.sentAmountDescription.localize()
		case .received:
			return S.TransactionDetails.receivedAmountDescription.localize()
		case .moved:
			return S.TransactionDetails.movedAmountDescription.localize()
		}
	}

	var addressTextFormat: String {
		switch self {
		case .sent:
			return S.TransactionDetails.to.localize()
		case .received:
			return S.TransactionDetails.from.localize()
		case .moved:
			return S.TransactionDetails.to.localize()
		}
	}
}
