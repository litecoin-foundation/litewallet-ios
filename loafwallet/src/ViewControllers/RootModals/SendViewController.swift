//
//  SendViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-30.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit
import LocalAuthentication
import BRCore
import FirebaseAnalytics
import SwiftUI

typealias PresentScan = ((@escaping ScanCompletion) -> Void)

private let verticalButtonPadding: CGFloat = 15.0
private let buttonSize = CGSize(width: 52.0, height: 32.0)

let swiftUICellPadding = 12.0
class SendViewController : UIViewController, Subscriber, ModalPresentable, Trackable {
      
    //MARK - Public
    var presentScan: PresentScan?
    var presentVerifyPin: ((String, @escaping VerifyPinCallback)->Void)?
    var onPublishSuccess: (()->Void)?
    var onResolvedSuccess: (()->Void)?
    var onResolutionFailure: ((String)->Void)?
    var parentView: UIView? //ModalPresentable
    var initialAddress: String?
    var isPresentedFromLock = false
    
    init(store: Store, sender: Sender, walletManager: WalletManager, initialAddress: String? = nil, initialRequest: PaymentRequest? = nil) {
        self.store = store
        self.sender = sender
        self.walletManager = walletManager
        self.initialAddress = initialAddress
        self.initialRequest = initialRequest
        self.currency = ShadowButton(title: S.Symbols.currencyButtonTitle(maxDigits: store.state.maxDigits), type: .tertiary)
        self.amountView = AmountViewController(store: store, isPinPadExpandedAtLaunch: false)
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK - Private
    deinit {
        store.unsubscribe(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    private let store: Store
    private let sender: Sender
    private let walletManager: WalletManager
    private let amountView: AmountViewController
    private let sendAddressCell = SendAddressHostingController()
    private let unstoppableCell = UIHostingController(rootView: UnstoppableDomainView(viewModel: UnstoppableDomainViewModel()))
    private let descriptionCell = DescriptionSendCell(placeholder: S.Send.descriptionLabel)
    private let orView = UILabel(font: .barlowMedium(size: 14.0), color: .litecoinSilver)
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
         
        
        // set as regular at didLoad
        walletManager.wallet?.feePerKb = store.state.fees.regular
        
        //polish parameters
        descriptionCell.backgroundColor = UIColor.litecoinGray
        amountView.view.backgroundColor = UIColor.litecoinGray
     
        orView.backgroundColor = UIColor.litecoinGray
        orView.text = "-- " + S.Fragments.or + " --"
        orView.textAlignment = .center
         
        view.addSubview(sendAddressCell.view)
        view.addSubview(orView)
        view.addSubview(unstoppableCell.view)
        view.addSubview(descriptionCell)
        view.addSubview(sendButtonCell.view)
 
        sendAddressCell.view.invalidateIntrinsicContentSize()
        sendAddressCell.view.constrainTopCorners(height: SendCell.defaultHeight)
        
        addChildViewController(amountView, layout: {
                                amountView.view.constrain([
                                                            amountView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                                            amountView.view.topAnchor.constraint(equalTo: unstoppableCell.view.bottomAnchor),
                                                            amountView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor) ]) })
        orView.constrain([
            orView.topAnchor.constraint(equalTo: sendAddressCell.view.bottomAnchor,constant: -5.0),
            orView.widthAnchor.constraint(equalTo: amountView.view.widthAnchor),
            orView.leadingAnchor.constraint(equalTo:  amountView.view.leadingAnchor),
            orView.heightAnchor.constraint(equalToConstant: 16.0) ])
        
        unstoppableCell.view.constrain([
            unstoppableCell.view.topAnchor.constraint(equalTo: orView.bottomAnchor),
                                        unstoppableCell.view.widthAnchor.constraint(equalTo: amountView.view.widthAnchor),
                                        unstoppableCell.view.leadingAnchor.constraint(equalTo:  amountView.view.leadingAnchor),
            unstoppableCell.view.heightAnchor.constraint(equalToConstant: SendCell.defaultHeight + 15.0) ])
        
        descriptionCell.constrain([
                                    descriptionCell.widthAnchor.constraint(equalTo: amountView.view.widthAnchor),
                                    descriptionCell.topAnchor.constraint(equalTo: amountView.view.bottomAnchor),
                                    descriptionCell.leadingAnchor.constraint(equalTo: amountView.view.leadingAnchor),
                                    descriptionCell.heightAnchor.constraint(equalTo: descriptionCell.textView.heightAnchor, constant: C.padding[3]) ])
        descriptionCell.accessoryView.constrain([
                                                    descriptionCell.accessoryView.constraint(.width, constant: 0.0) ])
        sendButtonCell.view.constrain([
            sendButtonCell.view.constraint(.leading, toView: view),
            sendButtonCell.view.constraint(.trailing, toView: view),
            sendButtonCell.view.constraint(toBottom: descriptionCell, constant: 0.0),
            sendButtonCell.view.constraint(.height, constant: C.Sizes.sendButtonHeight),
             sendButtonCell.view
                .bottomAnchor
                .constraint(equalTo: view.bottomAnchor, constant:  C.Sizes.sendButtonHeight - C.Sizes.buttonHeight) ])
         
        addButtonActions()
        store.subscribe(self, selector: { $0.walletState.balance != $1.walletState.balance },
                        callback: {
                            if let balance = $0.walletState.balance {
                                self.balance = balance
                            }
                        })
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
  

        descriptionCell.didReturn = { textView in
            textView.resignFirstResponder()
        }
        descriptionCell.didBeginEditing = { [weak self] in
            self?.amountView.closePinPad()
        }

        amountView.balanceTextForAmount = { [weak self] amount, rate in
            return self?.balanceTextForAmount(amount: amount, rate: rate)
        }
        
        amountView.didUpdateAmount = { [weak self] amount in
            self?.amount = amount
        }
        amountView.didUpdateFee = strongify(self) { myself, feeType in
            
            myself.feeType = feeType
            let fees = myself.store.state.fees
            
            switch feeType {
                case .regular: myself.walletManager.wallet?.feePerKb = fees.regular
                case .economy:  myself.walletManager.wallet?.feePerKb = fees.economy
                case .luxury: myself.walletManager.wallet?.feePerKb = fees.luxury
            }
            
            myself.amountView.updateBalanceLabel()
        }
        
        amountView.didChangeFirstResponder = { [weak self] isFirstResponder in
            if isFirstResponder {
                self?.descriptionCell.textView.resignFirstResponder()
            }
        }
        
        //MARK: - SendAddressView Model Callbacks
        sendAddressCell.rootView.viewModel.shouldPasteAddress = {
            self.pasteTapped()
        }
        
        sendAddressCell.rootView.viewModel.shouldScanAddress = {
            self.scanTapped()
        }
        
        //MARK: - Unstopplable Domain Model Callbacks
        unstoppableCell.rootView.viewModel.didResolveUDAddress = { resolvedUDAddress in
            
            ///Paste in Unstoppable Domain resolved LTC address to textField
            if !resolvedUDAddress.isEmpty {
                
                // Toast the successful resolution
                self.onResolvedSuccess?()
                self.sendAddressCell.rootView.viewModel.addressString = resolvedUDAddress
            }
        }
        
        unstoppableCell.rootView.viewModel.didFailToResolve = { errorMessage in
            // Toast the failure
            self.onResolutionFailure?(errorMessage)
            self.sendAddressCell.rootView.viewModel.addressString = ""
        }
        
        sendButtonCell.rootView.doSendTransaction = {
            self.sendTapped()
        }
    } 

    private func balanceTextForAmount(amount: Satoshis?, rate: Rate?) -> (NSAttributedString?, NSAttributedString?) {
        
        let balanceAmount = DisplayAmount(amount: Satoshis(rawValue: balance), state: store.state, selectedRate: rate, minimumFractionDigits: 2)
        let balanceText = balanceAmount.description
        
        let balanceOutput = String(format: S.Send.balance, balanceText)
        var feeOutput = ""
        var color: UIColor = .grayTextTint
        
        if let amount = amount, amount > 0 {
            let fee = sender.feeForTx(amount: amount.rawValue)
            let feeAmount = DisplayAmount(amount: Satoshis(rawValue: fee), state: store.state, selectedRate: rate, minimumFractionDigits: 2)
            
            let feeText = feeAmount.description.replacingZeroFeeWithOneCent()
            feeOutput = String(format: S.Send.fee, feeText)
            if (balance >= fee) && amount.rawValue > (balance - fee) {
                color = .cameraGuideNegative
            }
        }
        
        let balanceAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.customBody(size: 14.0),
            NSAttributedStringKey.foregroundColor: color
        ]
        
        let feeAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.customBody(size: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.grayTextTint
        ]
        
        return (NSAttributedString(string: balanceOutput, attributes: balanceAttributes), NSAttributedString(string: feeOutput, attributes: feeAttributes))
    }
    
    @objc private func pasteTapped() {
        
        guard let pasteboard = UIPasteboard.general.string, pasteboard.utf8.count > 0 else {
            return showAlert(title: S.LitewalletAlert.error, message: S.Send.emptyPasteboard, buttonLabel: S.Button.ok)
        }
        guard let request = PaymentRequest(string: pasteboard) else {
            return showAlert(title: S.Send.invalidAddressTitle, message: S.Send.invalidAddressOnPasteboard, buttonLabel: S.Button.ok)
        }
        
        sendAddressCell.rootView.viewModel.addressString = pasteboard

        handleRequest(request)
    }
    
    @objc private func scanTapped() {
        descriptionCell.textView.resignFirstResponder()
        
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
            
            guard let amount = amount else {
                return showAlert(title: S.LitewalletAlert.error, message: S.Send.noAmount, buttonLabel: S.Button.ok)
            }
            if let minOutput = walletManager.wallet?.minOutputAmount {
                guard amount.rawValue >= minOutput else {
                    let minOutputAmount = Amount(amount: minOutput, rate: Rate.empty, maxDigits: store.state.maxDigits)
                    let message = String(format: S.PaymentProtocol.Errors.smallPayment, minOutputAmount.string(isLtcSwapped: store.state.isLtcSwapped))
                    return showAlert(title: S.LitewalletAlert.error, message: message, buttonLabel: S.Button.ok)
                }
            }
            guard !(walletManager.wallet?.containsAddress(sendAddress) ?? false) else {
                return showAlert(title: S.LitewalletAlert.error, message: S.Send.containsAddress, buttonLabel: S.Button.ok)
            }
            guard amount.rawValue <= (walletManager.wallet?.maxOutputAmount ?? 0) else {
                return showAlert(title: S.LitewalletAlert.error, message: S.Send.insufficientFunds, buttonLabel: S.Button.ok)
            }
            guard sender.createTransaction(amount: amount.rawValue, to: sendAddress) else {
                return showAlert(title: S.LitewalletAlert.error, message: S.Send.createTransactionError, buttonLabel: S.Button.ok)
            }
        }
        else {
            NSLog("Error: transaction  is nil")
        }
        
        guard let amount = amount else {
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
        return
    }
    
    private func handleRequest(_ request: PaymentRequest) {
        switch request.type {
            case .local:
                
                if let amount = request.amount {
                    amountView.forceUpdateAmount(amount: amount)
                }
                if request.label != nil {
                    descriptionCell.content = request.label
                }
                
            case .remote:
                let loadingView = BRActivityViewController(message: S.Send.loadingRequest)
                present(loadingView, animated: true, completion: nil)
                request.fetchRemoteRequest(completion: { [weak self] request in
                    DispatchQueue.main.async {
                        loadingView.dismiss(animated: true, completion: {
                            if let paymentProtocolRequest = request?.paymentProtocolRequest {
                                self?.confirmProtocolRequest(protoReq: paymentProtocolRequest)
                            } else {
                                self?.showErrorMessage(S.Send.remoteRequestError)
                            }
                        })
                    }
                })
        }
    }
    
    private func send() {
        guard let rate = store.state.currentRate else { return }
        guard let feePerKb = walletManager.wallet?.feePerKb else { return }
        
        sender.send(biometricsMessage: S.VerifyPin.touchIdMessage,
                    rate: rate,
                    comment: descriptionCell.textView.text,
                    feePerKb: feePerKb,
                    verifyPinFunction: { [weak self] pinValidationCallback in
                        self?.presentVerifyPin?(S.VerifyPin.authorize) { [weak self] pin, vc in
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
                                LWAnalytics.logEventWithParameters(itemName:._20191105_DSL)
                                
                            case .creationError(let message):
                                self?.showAlert(title: S.Send.createTransactionError, message: message, buttonLabel: S.Button.ok)
                                self?.saveEvent("send.publishFailed", attributes: ["errorMessage": message])
                            case .publishFailure(let error):
                                if case .posixError(let code, let description) = error {
                                    self?.showAlert(title: S.SecurityAlerts.sendFailure, message: "\(description) (\(code))", buttonLabel: S.Button.ok)
                                    self?.saveEvent("send.publishFailed", attributes: ["errorMessage": "\(description) (\(code))"])
                                }
                        }
                    })
    }
    
    func confirmProtocolRequest(protoReq: PaymentProtocolRequest) {
        guard let firstOutput = protoReq.details.outputs.first else { return }
        guard let wallet = walletManager.wallet else { return }
        
        let address = firstOutput.swiftAddress
        let isValid = protoReq.isValid()
        var isOutputTooSmall = false
        
        if let errorMessage = protoReq.errorMessage, errorMessage == S.PaymentProtocol.Errors.requestExpired, !isValid {
            return showAlert(title: S.PaymentProtocol.Errors.badPaymentRequest, message: errorMessage, buttonLabel: S.Button.ok)
        }
        
        //TODO: check for duplicates of already paid requests
        var requestAmount = Satoshis(0)
        protoReq.details.outputs.forEach { output in
            if output.amount > 0 && output.amount < wallet.minOutputAmount {
                isOutputTooSmall = true
            }
            requestAmount += output.amount
        }
        
        if wallet.containsAddress(address) {
            return showAlert(title: S.LitewalletAlert.warning, message: S.Send.containsAddress, buttonLabel: S.Button.ok)
        } else if wallet.addressIsUsed(address) && !didIgnoreUsedAddressWarning {
            let message = "\(S.Send.UsedAddress.title)\n\n\(S.Send.UsedAddress.firstLine)\n\n\(S.Send.UsedAddress.secondLine)"
            return showError(title: S.LitewalletAlert.warning, message: message, ignore: { [weak self] in
                self?.didIgnoreUsedAddressWarning = true
                self?.confirmProtocolRequest(protoReq: protoReq)
            })
        } else if let message = protoReq.errorMessage, message.utf8.count > 0 && (protoReq.commonName?.utf8.count)! > 0 && !didIgnoreIdentityNotCertified {
            return showError(title: S.Send.identityNotCertified, message: message, ignore: { [weak self] in
                self?.didIgnoreIdentityNotCertified = true
                self?.confirmProtocolRequest(protoReq: protoReq)
            })
        } else if requestAmount < wallet.minOutputAmount {
            let amount = Amount(amount: wallet.minOutputAmount, rate: Rate.empty, maxDigits: store.state.maxDigits)
            let message = String(format: S.PaymentProtocol.Errors.smallPayment, amount.bits)
            return showAlert(title: S.PaymentProtocol.Errors.smallOutputErrorTitle, message: message, buttonLabel: S.Button.ok)
        } else if isOutputTooSmall {
            let amount = Amount(amount: wallet.minOutputAmount, rate: Rate.empty, maxDigits: store.state.maxDigits)
            let message = String(format: S.PaymentProtocol.Errors.smallTransaction, amount.bits)
            return showAlert(title: S.PaymentProtocol.Errors.smallOutputErrorTitle, message: message, buttonLabel: S.Button.ok)
        }
         
        if requestAmount > 0 {
            amountView.forceUpdateAmount(amount: requestAmount)
        }
        descriptionCell.content = protoReq.details.memo
        
        if requestAmount == 0 {
            if let amount = amount {
                guard sender.createTransaction(amount: amount.rawValue, to: address) else {
                    return showAlert(title: S.LitewalletAlert.error, message: S.Send.createTransactionError, buttonLabel: S.Button.ok)
                }
            }
        }
    }
    
    private func showError(title: String, message: String, ignore: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: S.Button.ignore, style: .default, handler: { _ in
            ignore()
        }))
        alertController.addAction(UIAlertAction(title: S.Button.cancel, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Keyboard Notifications
    @objc private func keyboardWillShow(notification: Notification) {
        copyKeyboardChangeAnimation(notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        copyKeyboardChangeAnimation(notification: notification)
    }
    
    //TODO - maybe put this in ModalPresentable?
    private func copyKeyboardChangeAnimation(notification: Notification) {
        guard let info = KeyboardNotificationInfo(notification.userInfo) else { return }
        UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: {
            guard let parentView = self.parentView else { return }
            parentView.frame = parentView.frame.offsetBy(dx: 0, dy: info.deltaY)
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SendViewController : ModalDisplayable {
    var faqArticleId: String? {
        return ArticleIds.sendBitcoin
    }
    
    var modalTitle: String {
        return S.Send.title
    }
}


