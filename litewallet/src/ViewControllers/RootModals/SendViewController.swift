import BRCore
import FirebaseAnalytics
import KeychainAccess
import LocalAuthentication
import SwiftUI
import UIKit

typealias PresentScan = (@escaping ScanCompletion) -> Void

let swiftUICellPadding = 12.0

class SendViewController: UIViewController, Subscriber, ModalPresentable, Trackable {
	// MARK: - Public

	var presentScan: PresentScan?
	var presentVerifyPin: ((String, @escaping VerifyPinCallback) -> Void)?
	var onPublishSuccess: (() -> Void)?
	var onResolvedSuccess: (() -> Void)?
	var onResolutionFailure: ((String) -> Void)?
	var parentView: UIView? // ModalPresentable
	var initialAddress: String?
	var isPresentedFromLock = false
	var hasActivatedInlineFees: Bool = true

	private
	let keychainPreferences = Keychain(service: "litewallet.user-prefs")

	init(store: Store, sender: Sender, walletManager: WalletManager, initialAddress: String? = nil, initialRequest: PaymentRequest? = nil)
	{
		self.store = store
		self.sender = sender
		self.walletManager = walletManager
		self.initialAddress = initialAddress
		self.initialRequest = initialRequest
		currency = ShadowButton(title: S.Symbols.currencyButtonTitle(maxDigits: store.state.maxDigits), type: .tertiary)

		/// User Preference
		if let opsPreference = keychainPreferences["hasAcceptedFees"],
		   opsPreference == "false"
		{
			hasActivatedInlineFees = false
		} else {
			keychainPreferences["has-accepted-fees"] = "true"
		}

		amountView = AmountViewController(store: store, isPinPadExpandedAtLaunch: false, hasAcceptedFees: hasActivatedInlineFees)

		LWAnalytics.logEventWithParameters(itemName: ._20191105_VSC)

		super.init(nibName: nil, bundle: nil)
	}

	// MARK: - Private

	deinit {
		store.unsubscribe(self)
		NotificationCenter.default.removeObserver(self)
	}

	private let store: Store
	private let sender: Sender
	private let walletManager: WalletManager
	private let sendAddressCell = SendAddressHostingController()
	private let amountView: AmountViewController
	private let memoCell = DescriptionSendCell(placeholder: S.Send.descriptionLabel.localize())
	private var sendButtonCell = SendButtonHostingController()
	private let currency: ShadowButton
	private let currencyBorder = UIView(color: .secondaryShadow)
	private var pinPadHeightConstraint: NSLayoutConstraint?
	private var balance: UInt64 = 0
	private var amount: Satoshis?
	private var didIgnoreUsedAddressWarning = false
	private var didIgnoreIdentityNotCertified = false
	private let initialRequest: PaymentRequest?
	private let confirmTransitioningDelegate = TransitioningDelegate()
	private var feeType: FeeType?

	override func viewDidLoad() {
		view.backgroundColor = UIColor.litecoinGray

		// set as regular at didLoad
		walletManager.wallet?.feePerKb = store.state.fees.regular

		// polish parameters
		memoCell.backgroundColor = UIColor.litecoinGray
		amountView.view.backgroundColor = UIColor.litecoinGray

		view.addSubview(sendAddressCell.view)
		view.addSubview(memoCell)
		view.addSubview(sendButtonCell.view)

		sendAddressCell.view.invalidateIntrinsicContentSize()
		sendAddressCell.view.constrainTopCorners(height: SendCell.defaultHeight)

		addChildViewController(amountView, layout: {
			amountView.view.constrain([
				amountView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				amountView.view.topAnchor.constraint(equalTo: sendAddressCell.view.bottomAnchor),
				amountView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			])
		})

		memoCell.constrain([
			memoCell.widthAnchor.constraint(equalTo: amountView.view.widthAnchor),
			memoCell.topAnchor.constraint(equalTo: amountView.view.bottomAnchor),
			memoCell.leadingAnchor.constraint(equalTo: amountView.view.leadingAnchor),
			memoCell.heightAnchor.constraint(equalTo: memoCell.textView.heightAnchor, constant: C.padding[3]),
		])
		memoCell.accessoryView.constrain([
			memoCell.accessoryView.constraint(.width, constant: 0.0),
		])
		sendButtonCell.view.constrain([
			sendButtonCell.view.constraint(.leading, toView: view),
			sendButtonCell.view.constraint(.trailing, toView: view),
			sendButtonCell.view.constraint(toBottom: memoCell, constant: 0.0),
			sendButtonCell.view.constraint(.height, constant: C.Sizes.sendButtonHeight),
			sendButtonCell.view
				.bottomAnchor
				.constraint(equalTo: view.bottomAnchor, constant: E.isIPhoneX ? -C.padding[5] : -C.padding[2]),
		])

		addButtonActions()
		store.subscribe(self, selector: { $0.walletState.balance != $1.walletState.balance },
		                callback: {
		                	if let balance = $0.walletState.balance {
		                		self.balance = balance
		                	}
		                })

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if initialAddress != nil {
			amountView.expandPinPad()
		} else if let initialRequest = initialRequest {
			handleRequest(initialRequest)
		}
	}

	private func addButtonActions() {
		memoCell.didReturn = { textView in
			textView.resignFirstResponder()
		}
		memoCell.didBeginEditing = { [weak self] in
			self?.amountView.closePinPad()
		}

		amountView.balanceTextForAmount = { [weak self] amount, rate in
			self?.balanceTextForAmount(amount: amount, rate: rate)
		}

		amountView.didUpdateAmount = { [weak self] amount in
			self?.amount = amount
		}
		amountView.didUpdateFee = strongify(self) { myself, feeType in
			myself.feeType = feeType
			let fees = myself.store.state.fees

			switch feeType {
			case .regular: myself.walletManager.wallet?.feePerKb = fees.regular
			case .economy: myself.walletManager.wallet?.feePerKb = fees.economy
			case .luxury: myself.walletManager.wallet?.feePerKb = fees.luxury
			}

			myself.amountView.updateBalanceLabel()
		}

		amountView.didChangeFirstResponder = { [weak self] isFirstResponder in
			if isFirstResponder {
				self?.memoCell.textView.resignFirstResponder()
			}
		}

		// MARK: - SendAddressView Model Callbacks

		sendAddressCell.rootView.viewModel.shouldPasteAddress = {
			self.pasteTapped()
		}

		sendAddressCell.rootView.viewModel.shouldScanAddress = {
			self.scanTapped()
		}

		sendButtonCell.rootView.doSendTransaction = {
			self.sendTapped()
		}
	}

	private func balanceTextForAmount(amount: Satoshis?, rate: Rate?) -> (NSAttributedString?, NSAttributedString?)
	{
		let balanceAmount = DisplayAmount(amount: Satoshis(rawValue: balance), state: store.state, selectedRate: rate, minimumFractionDigits: 2)
		let balanceText = balanceAmount.description

		let balanceOutput = String(format: S.Send.balance.localize(), balanceText)
		var feeOutput = ""
		var color: UIColor = .grayTextTint

		if let amount = amount, amount > 0 {
			let fee = sender.feeForTx(amount: amount.rawValue)
			let feeAmount = DisplayAmount(amount: Satoshis(rawValue: fee), state: store.state, selectedRate: rate, minimumFractionDigits: 2)

			let feeText = feeAmount.description.replacingZeroFeeWithTenCents()
			feeOutput = String(format: S.Send.fee.localize(), feeText)
			if balance >= fee, amount.rawValue > (balance - fee) {
				color = .cameraGuideNegative
			}
		}

		let balanceAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.customBody(size: 14.0),
			NSAttributedString.Key.foregroundColor: color,
		]

		let feeAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.customBody(size: 14.0),
			NSAttributedString.Key.foregroundColor: UIColor.grayTextTint,
		]

		return (NSAttributedString(string: balanceOutput, attributes: balanceAttributes), NSAttributedString(string: feeOutput, attributes: feeAttributes))
	}

	@objc private func pasteTapped() {
		guard let pasteboard = UIPasteboard.general.string, !pasteboard.utf8.isEmpty
		else {
			return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.emptyPasteboard.localize(), buttonLabel: S.Button.ok.localize())
		}
		guard let request = PaymentRequest(string: pasteboard)
		else {
			return showAlert(title: S.Send.invalidAddressTitle.localize(), message: S.Send.invalidAddressOnPasteboard.localize(), buttonLabel: S.Button.ok.localize())
		}

		sendAddressCell.rootView.viewModel.addressString = pasteboard

		handleRequest(request)
	}

	@objc private func scanTapped() {
		memoCell.textView.resignFirstResponder()

		presentScan? { [weak self] paymentRequest in
			guard let request = paymentRequest else { return }
			guard let destinationAddress = paymentRequest?.toAddress else { return }

			self?.sendAddressCell.rootView.viewModel.addressString = destinationAddress
			self?.handleRequest(request)
		}
	}

	@objc private func sendTapped() {
		let sendAddress = sendAddressCell.rootView.viewModel.addressString

		if sender.transaction == nil {
			guard let amount = amount
			else {
				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.noAmount.localize(), buttonLabel: S.Button.ok.localize())
			}
			if let minOutput = walletManager.wallet?.minOutputAmount {
				guard amount.rawValue >= minOutput
				else {
					let minOutputAmount = Amount(amount: minOutput, rate: Rate.empty, maxDigits: store.state.maxDigits)
					let message = String(format: S.PaymentProtocol.Errors.smallPayment.localize(), minOutputAmount.string(isLtcSwapped: store.state.isLtcSwapped))
					return showAlert(title: S.LitewalletAlert.error.localize(), message: message, buttonLabel: S.Button.ok.localize())
				}
			}
			guard !(walletManager.wallet?.containsAddress(sendAddress) ?? false)
			else {
				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.containsAddress.localize(), buttonLabel: S.Button.ok.localize())
			}
			guard amount.rawValue <= (walletManager.wallet?.maxOutputAmount ?? 0)
			else {
				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.insufficientFunds.localize(), buttonLabel: S.Button.ok.localize())
			}
			guard sender.createTransaction(amount: amount.rawValue, to: sendAddress)
			else {
				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.createTransactionError.localize(), buttonLabel: S.Button.ok.localize())
			}
		} else {
			NSLog("Error: transaction  is nil")
		}

		guard let amount = amount
		else {
			NSLog("Error: Amount  is nil")
			return
		}

		let confirm = ConfirmationViewController(amount: amount, fee: Satoshis(sender.fee), feeType: feeType ?? .regular, state: store.state, selectedRate: amountView.selectedRate, minimumFractionDigits: amountView.minimumFractionDigits, address: sendAddress, isUsingBiometrics: sender.canUseBiometrics)

		confirm.successCallback = {
			confirm.dismiss(animated: true, completion: {
				self.send()
			})
		}
		confirm.cancelCallback = {
			confirm.dismiss(animated: true, completion: {
				self.sender.transaction = nil
			})
		}
		confirmTransitioningDelegate.shouldShowMaskView = false
		confirm.transitioningDelegate = confirmTransitioningDelegate
		confirm.modalPresentationStyle = .overFullScreen
		confirm.modalPresentationCapturesStatusBarAppearance = true
		present(confirm, animated: true, completion: nil)
	}

//	@objc private func sendTapped() {
//		let sendAddress = sendAddressCell.rootView.viewModel.addressString
//
//		if sender.transaction == nil {
//			/// Main Transaction
//			guard let amount = amount
//			else {
//				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.noAmount.localize(), buttonLabel: S.Button.ok.localize())
//			}
//			if let minOutput = walletManager.wallet?.minOutputAmount {
//				guard amount.rawValue >= minOutput
//				else {
//					let minOutputAmount = Amount(amount: minOutput, rate: Rate.empty, maxDigits: store.state.maxDigits)
//					let message = String(format: S.PaymentProtocol.Errors.smallPayment.localize(), minOutputAmount.string(isLtcSwapped: store.state.isLtcSwapped))
//					return showAlert(title: S.LitewalletAlert.error.localize(), message: message, buttonLabel: S.Button.ok.localize())
//				}
//			}
//			guard !(walletManager.wallet?.containsAddress(sendAddress) ?? false)
//			else {
//				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.containsAddress.localize(), buttonLabel: S.Button.ok.localize())
//			}
//			guard amount.rawValue <= (walletManager.wallet?.maxOutputAmount ?? 0)
//			else {
//				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.insufficientFunds.localize(), buttonLabel: S.Button.ok.localize())
//			}
//
//			/// Fees
//
//			let opsFee = sender.createTransaction(amount: tieredOpsFee(amount: amount.rawValue), to: Partner.partnerKeyPath(name: .litewalletOps))
//
//			guard sender.createTransaction(amount: amount.rawValue, to: sendAddress)
//			else {
//				return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.createTransactionError.localize(), buttonLabel: S.Button.ok.localize())
//			}
//		} else {
//			NSLog("Error: transaction  is nil")
//		}
//
//		guard let amount = amount
//		else {
//			NSLog("Error: Amount  is nil")
//			return
//		}
//
//		let confirm = ConfirmationViewController(amount: amount, fee: Satoshis(sender.fee), feeType: feeType ?? .regular, state: store.state, selectedRate: amountView.selectedRate, minimumFractionDigits: amountView.minimumFractionDigits, address: sendAddress, isUsingBiometrics: sender.canUseBiometrics)
//
//		confirm.successCallback = {
//			confirm.dismiss(animated: true, completion: {
//				self.send()
//			})
//		}
//		confirm.cancelCallback = {
//			confirm.dismiss(animated: true, completion: {
//				self.sender.transaction = nil
//			})
//		}
//		confirmTransitioningDelegate.shouldShowMaskView = false
//		confirm.transitioningDelegate = confirmTransitioningDelegate
//		confirm.modalPresentationStyle = .overFullScreen
//		confirm.modalPresentationCapturesStatusBarAppearance = true
//		present(confirm, animated: true, completion: nil)
//	}

	private func handleRequest(_ request: PaymentRequest) {
		switch request.type {
		case .local:

			if let amount = request.amount {
				amountView.forceUpdateAmount(amount: amount)
			}
			if request.label != nil {
				memoCell.content = request.label
			}

		case .remote:
			let loadingView = BRActivityViewController(message: S.Send.loadingRequest.localize())
			present(loadingView, animated: true, completion: nil)
			request.fetchRemoteRequest(completion: { [weak self] request in
				DispatchQueue.main.async {
					loadingView.dismiss(animated: true, completion: {
						if let paymentProtocolRequest = request?.paymentProtocolRequest {
							self?.confirmProtocolRequest(protoReq: paymentProtocolRequest)
						} else {
							self?.showErrorMessage(S.Send.remoteRequestError.localize())
						}
					})
				}
			})
		}
	}

	private func send() {
		guard let rate = store.state.currentRate else { return }
		guard let feePerKb = walletManager.wallet?.feePerKb else { return }

		sender.send(biometricsMessage: S.VerifyPin.touchIdMessage.localize(),
		            rate: rate,
		            comment: memoCell.textView.text,
		            feePerKb: feePerKb,
		            verifyPinFunction: { [weak self] pinValidationCallback in
		            	self?.presentVerifyPin?(S.VerifyPin.authorize.localize()) { [weak self] pin, vc in
		            		if pinValidationCallback(pin) {
		            			vc.dismiss(animated: true, completion: {
		            				self?.parent?.view.isFrameChangeBlocked = false
		            			})
		            			return true
		            		} else {
		            			return false
		            		}
		            	}
		            }, completion: { [weak self] result in
		            	switch result {
		            	case .success:
		            		self?.dismiss(animated: true, completion: {
		            			guard let myself = self else { return }
		            			myself.store.trigger(name: .showStatusBar)
		            			if myself.isPresentedFromLock {
		            				myself.store.trigger(name: .loginFromSend)
		            			}
		            			myself.onPublishSuccess?()
		            		})
		            		self?.saveEvent("send.success")
		            		LWAnalytics.logEventWithParameters(itemName: ._20191105_DSL)

		            	case let .creationError(message):
		            		self?.showAlert(title: S.Send.createTransactionError.localize(), message: message, buttonLabel: S.Button.ok.localize())
		            		self?.saveEvent("send.publishFailed", attributes: ["errorMessage": message])
		            	case let .publishFailure(error):
		            		if case let .posixError(code, description) = error {
		            			self?.showAlert(title: S.SecurityAlerts.sendFailure.localize(), message: "\(description) (\(code))", buttonLabel: S.Button.ok.localize())
		            			self?.saveEvent("send.publishFailed", attributes: ["errorMessage": "\(description) (\(code))"])
		            		}
		            	}
		            })
	}

	func confirmProtocolRequest(protoReq: PaymentProtocolRequest) {
		guard let firstOutput = protoReq.details.outputs.first else { return }
		guard let wallet = walletManager.wallet else { return }

		let address = firstOutput.updatedSwiftAddress
		let isValid = protoReq.isValid()
		var isOutputTooSmall = false

		if let errorMessage = protoReq.errorMessage, errorMessage == S.PaymentProtocol.Errors.requestExpired.localize(), !isValid
		{
			return showAlert(title: S.PaymentProtocol.Errors.badPaymentRequest.localize(), message: errorMessage, buttonLabel: S.Button.ok.localize())
		}

		// TODO: check for duplicates of already paid requests
		var requestAmount = Satoshis(0)
		protoReq.details.outputs.forEach { output in
			if output.amount > 0, output.amount < wallet.minOutputAmount {
				isOutputTooSmall = true
			}
			requestAmount += output.amount
		}

		if wallet.containsAddress(address) {
			return showAlert(title: S.LitewalletAlert.warning.localize(), message: S.Send.containsAddress.localize(), buttonLabel: S.Button.ok.localize())
		} else if wallet.addressIsUsed(address), !didIgnoreUsedAddressWarning {
			let message = "\(S.Send.UsedAddress.title.localize())\n\n\(S.Send.UsedAddress.firstLine.localize())\n\n\(S.Send.UsedAddress.secondLine.localize())"
			return showError(title: S.LitewalletAlert.warning.localize(), message: message, ignore: { [weak self] in
				self?.didIgnoreUsedAddressWarning = true
				self?.confirmProtocolRequest(protoReq: protoReq)
			})
		} else if let message = protoReq.errorMessage, !message.utf8.isEmpty, (protoReq.commonName?.utf8.count)! > 0, !didIgnoreIdentityNotCertified
		{
			return showError(title: S.Send.identityNotCertified.localize(), message: message, ignore: { [weak self] in
				self?.didIgnoreIdentityNotCertified = true
				self?.confirmProtocolRequest(protoReq: protoReq)
			})
		} else if requestAmount < wallet.minOutputAmount {
			let amount = Amount(amount: wallet.minOutputAmount, rate: Rate.empty, maxDigits: store.state.maxDigits)
			let message = String(format: S.PaymentProtocol.Errors.smallPayment.localize(), amount.bits)
			return showAlert(title: S.PaymentProtocol.Errors.smallOutputErrorTitle.localize(), message: message, buttonLabel: S.Button.ok.localize())
		} else if isOutputTooSmall {
			let amount = Amount(amount: wallet.minOutputAmount, rate: Rate.empty, maxDigits: store.state.maxDigits)
			let message = String(format: S.PaymentProtocol.Errors.smallTransaction.localize(), amount.bits)
			return showAlert(title: S.PaymentProtocol.Errors.smallOutputErrorTitle.localize(), message: message, buttonLabel: S.Button.ok.localize())
		}

		if requestAmount > 0 {
			amountView.forceUpdateAmount(amount: requestAmount)
		}
		memoCell.content = protoReq.details.memo

		if requestAmount == 0 {
			if let amount = amount {
				guard sender.createTransaction(amount: amount.rawValue, to: address)
				else {
					return showAlert(title: S.LitewalletAlert.error.localize(), message: S.Send.createTransactionError.localize(), buttonLabel: S.Button.ok.localize())
				}
			}
		}
	}

	private func showError(title: String, message: String, ignore: @escaping () -> Void) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: S.Button.ignore.localize(), style: .default, handler: { _ in
			ignore()
		}))
		alertController.addAction(UIAlertAction(title: S.Button.cancel.localize(), style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}

	// MARK: - Keyboard Notifications

	@objc private func keyboardWillShow(notification: Notification) {
		copyKeyboardChangeAnimation(notification: notification)
	}

	@objc private func keyboardWillHide(notification: Notification) {
		copyKeyboardChangeAnimation(notification: notification)
	}

	// TODO: - maybe put this in ModalPresentable?
	private func copyKeyboardChangeAnimation(notification: Notification) {
		guard let info = KeyboardNotificationInfo(notification.userInfo) else { return }
		UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: {
			guard let parentView = self.parentView else { return }
			parentView.frame = parentView.frame.offsetBy(dx: 0, dy: info.deltaY)
		}, completion: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension SendViewController: ModalDisplayable {
	var faqArticleId: String? {
		return ArticleIds.sendBitcoin
	}

	var modalTitle: String {
		return S.Send.title.localize()
	}
}

//            let litewalletFees = BRTxOutput(address: <#T##(CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar)#>, amount: <#T##UInt64#>, script: <#T##UnsafeMutablePointer<UInt8>!#>, scriptLen: <#T##Int#>)
