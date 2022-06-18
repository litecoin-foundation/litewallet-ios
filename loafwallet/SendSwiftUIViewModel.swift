//
//  SendSwiftUIViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/4/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit
import LocalAuthentication
import BRCore
import FirebaseAnalytics


class SendSwiftUIViewModel: ObservableObject, Subscriber, ModalPresentable, Trackable {
    
    //MARK: - Combine Variables
    @Published
    var isDomainResolving: Bool = false
    
    @Published
    var searchString: String = ""
    
    @Published
    var memoString: String = ""
    
    @Published
    var sendAddress: String = ""
    
    @Published
    var sendAmount: String = ""
    
    @Published
    var noteString: String = ""
      
    @Published
    var isOnFiat: Bool = false
    
    @Published
    var feeType: FeeType = .regular
    
    
    
//    @Published
//    var searchString: String = ""
//
//    @Published
//    var placeholderString: String = S.Send.UnstoppableDomains.placeholder
//

    
    //MARK: - Public Variables
     
    var presentScan: PresentScan?
    
    var presentVerifyPin: ((String, @escaping VerifyPinCallback)->Void)?
    
    var onPublishSuccess: (()->Void)?
    
    var onResolvedSuccess: (()->Void)?
    
    var onResolutionFailure: ((String)->Void)?
    
    var parentView: UIView? //ModalPresentable
    
    var initialAddress: String?
    
    var isPresentedFromLock = false
    
     
    //MARK: - Private Variables
    
    private let store: Store
    
    private let sender: Sender
    
    private let walletManager: WalletManager
    
//    private let amountView: AmountViewController
//
//    private let unstoppableCell = UIHostingController(rootView: UnstoppableDomainView(viewModel: UnstoppableDomainViewModel()))
//
//    private let descriptionCell = DescriptionSendCell(placeholder: S.Send.descriptionLabel)
//
//    private var sendButton = ShadowButton(title: S.Send.sendLabel, type: .flatLitecoinBlue)
    
//    private let currency: ShadowButton
    
    private let currencyBorder = UIView(color: .secondaryShadow)
    
//    private var pinPadHeightConstraint: NSLayoutConstraint?
    
    private var balance: UInt64 = 0
    
    private var amount: Satoshis?
    
    private var didIgnoreUsedAddressWarning = false
    
    private var didIgnoreIdentityNotCertified = false
    
    private let initialRequest: PaymentRequest?
    
    private let confirmTransitioningDelegate = TransitioningDelegate()

//    private var ltcAddress = ""
//    private var dateFormatter: DateFormatter? {
//
//        didSet {
//            dateFormatter = DateFormatter()
//            dateFormatter?.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        }
//    }
    
    init(store: Store,
         sender: Sender,
         walletManager: WalletManager,
         initialAddress: String? = nil,
         initialRequest: PaymentRequest? = nil) {
        
         self.store = store
        
         self.sender = sender
        
         self.walletManager = walletManager
        
         self.initialAddress = initialAddress
        
         self.initialRequest = initialRequest
        
         //self.currency = ShadowButton(title: S.Symbols.currencyButtonTitle(maxDigits: store.state.maxDigits), type: .tertiary)
         
        //self.amountView = AmountViewController(store: store, isPinPadExpandedAtLaunch: false)
        
        walletManager.wallet?.feePerKb = store.state.fees.regular
        
        startSubscriptions()

    }
     
    deinit {
        store.unsubscribe(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startSubscriptions() {
        store.subscribe(self, selector: { $0.walletState.balance != $1.walletState.balance },
                        callback: {
            if let balance = $0.walletState.balance {
                self.balance = balance
            }
        })
    }
    
    @objc func pasteTapped() {
        guard let pasteboard = UIPasteboard.general.string, pasteboard.utf8.count > 0 else {
            return showAlert(title: S.LitewalletAlert.error, message: S.Send.emptyPasteboard, buttonLabel: S.Button.ok)
        }
        guard let request = PaymentRequest(string: pasteboard) else {
            return showAlert(title: S.Send.invalidAddressTitle, message: S.Send.invalidAddressOnPasteboard, buttonLabel: S.Button.ok)
        }
        handleRequest(request)
    }
    
    func showErrorAlertMessage(_ message: String) {
        let alert = UIAlertController(title: S.LitewalletAlert.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: S.Button.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showOKAlertMessage(title: String, message: String, buttonLabel: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: S.Button.ok, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func addButtonActions() {
//        addressCell.paste.addTarget(self, action: #selector(SendViewController.pasteTapped), for: .touchUpInside)
        addressCell.scan.addTarget(self, action: #selector(SendViewController.scanTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        descriptionCell.didReturn = { textView in
            textView.resignFirstResponder()
        }
        descriptionCell.didBeginEditing = { [weak self] in
            self?.amountView.closePinPad()
        }
        addressCell.didBeginEditing = strongify(self) { myself in
            myself.amountView.closePinPad()
        }
        addressCell.didReceivePaymentRequest = { [weak self] request in
            self?.handleRequest(request)
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
                self?.addressCell.textField.resignFirstResponder()
            }
        }
        
        //MARK: - Unstopplable Domain Callbacks
        unstoppableCell.rootView.viewModel.shouldClearAddressField = {
            
            ///clear the existing textfield
            self.addressCell.textField.becomeFirstResponder()
            self.addressCell.textField.text = ""
        }
        
        unstoppableCell.rootView.viewModel.didResolveUDAddress = { resolvedUDAddress in
            
            ///Paste in Unstoppable Domain resolved LTC address to textField
            self.addressCell.textField.becomeFirstResponder()
            self.addressCell.textField.isHidden = false
            
            if !resolvedUDAddress.isEmpty {
                
                // Toast the successful resolution
                self.onResolvedSuccess?()
                self.addressCell.textField.text = resolvedUDAddress
            }
            
        }
        
        unstoppableCell.rootView.viewModel.didFailToResolve = { errorMessage in
            // Toast the failure
            self.onResolutionFailure?(errorMessage)
        }
        
    }

}
/////FOR MODEL/////
///
///
///
//guard !store.state.walletState.isRescanning else {
//    let alert = UIAlertController(title: S.LitewalletAlert.error, message: S.Send.isRescanning, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: S.Button.ok, style: .cancel, handler: nil))
//    topViewController?.present(alert, animated: true, completion: nil)
//    return nil
//}
//guard let walletManager = walletManager else { return nil }
//guard let kvStore = walletManager.apiClient?.kv else { return nil }
//
//
//let sendSwiftUIVC = UIHostingController(rootView: SendSwiftUIView())
//
//let bounds = UIScreen.main.bounds
//let width = bounds.size.width
//
//let modalRoot = ModalViewController(childViewController: sendSwiftUIVC, store: store, isRootSwiftUI: true)
//modalRoot.view.frame = CGRect(x: 0, y: 0, width: width, height: bounds.size.height)
//
////        let sendVC = SendViewController(store: store, sender: Sender(walletManager: walletManager, kvStore: kvStore, store: store),  walletManager: walletManager, initialRequest: currentRequest)
////        currentRequest = nil
////
////        if store.state.isLoginRequired {
////            sendVC.isPresentedFromLock = true
////        }
////
////        let root = ModalViewController(childViewController: sendSwiftUIVC, store: store)
////        sendVC.presentScan = presentScan(parent: root)
////        sendVC.presentVerifyPin = { [weak self, weak root] bodyText, callback in
////            guard let myself = self else { return }
////            let vc = VerifyPinViewController(bodyText: bodyText, pinLength: myself.store.state.pinLength, callback: callback)
////            vc.transitioningDelegate = self?.verifyPinTransitionDelegate
////            vc.modalPresentationStyle = .overFullScreen
////            vc.modalPresentationCapturesStatusBarAppearance = true
////            root?.view.isFrameChangeBlocked = true
////            root?.present(vc, animated: true, completion: nil)
////        }
////        sendVC.onPublishSuccess = { [weak self] in
////            self?.presentAlert(.sendSuccess, completion: {})
////        }
////
////        sendVC.onResolvedSuccess = { [weak self] in
////            self?.presentAlert(.resolvedSuccess, completion: {})
////        }
////
////        sendVC.onResolutionFailure = { [weak self] failureMessage in
////            self?.presentFailureAlert(.failedResolution, errorMessage: failureMessage, completion: {})
////        }


