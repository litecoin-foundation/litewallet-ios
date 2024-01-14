import Foundation

class SendAddressCellViewModel: ObservableObject {
	// MARK: - Combine Variables

	@Published
	var addressString: String = ""

	@Published
	var amountString: String = ""

	@Published
	var didUpdatePaste: Bool = false

	// MARK: - Public Variables

	var shouldPasteAddress: (() -> Void)?

	var shouldScanAddress: (() -> Void)?

	var balanceTextForAmount: ((Satoshis?, Rate?) -> (NSAttributedString?, NSAttributedString?)?)?
	var didUpdateAmount: ((Satoshis?) -> Void)?
	var didChangeFirstResponder: ((Bool) -> Void)?
	var didShowFiat: ((_ isShowingFiat: Bool) -> Void)?

	init()
	{}

	//    amountView.balanceTextForAmount = { [weak self] amount, rate in
	//        self?.balanceTextForAmount(amount: amount, rate: rate)
	//    }
//
	//    amountView.didUpdateAmount = { [weak self] amount in
	//        self?.amount = amount
	//    }
	//    amountView.didUpdateFee = strongify(self) { myself, feeType in
	//        myself.feeType = feeType
	//        let fees = myself.store.state.fees
//
	//        switch feeType {
	//            case .regular: myself.walletManager.wallet?.feePerKb = fees.regular
	//            case .economy: myself.walletManager.wallet?.feePerKb = fees.economy
	//            case .luxury: myself.walletManager.wallet?.feePerKb = fees.luxury
	//        }
//
	//        myself.amountView.updateBalanceLabel()
	//    }
//
	//    amountView.didChangeFirstResponder = { [weak self] isFirstResponder in
	//        if isFirstResponder {
	//            self?.memoCell.textView.resignFirstResponder()
	//        }
	//    }
}
