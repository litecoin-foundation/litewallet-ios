import Foundation

struct CardWalletDetails: Decodable {
	var balance: Double?
	var ltcAddress: String?
	var createdAt: String?
	var updatedAt: String?
	var availableBalance: Double?
	var withdrawableBalance: Double?
	var spendableBalance: Double?

	enum CodingKeys: String, CodingKey {
		case balance
		case ltcAddress = "ltc_address"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case availableBalance = "available_balance"
		case withdrawableBalance = "withdrawable_balance"
		case spendableBalance = "spendable_balance"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		balance = try? container.decode(Double.self, forKey: .balance)
		ltcAddress = try? container.decode(String.self, forKey: .ltcAddress)
		createdAt = try? container.decode(String.self, forKey: .createdAt)
		updatedAt = try? container.decode(String.self, forKey: .updatedAt)
		availableBalance = try? container.decode(Double.self, forKey: .availableBalance)
		withdrawableBalance = try? container.decode(Double.self, forKey: .withdrawableBalance)
		spendableBalance = try? container.decode(Double.self, forKey: .spendableBalance)
	}
}
