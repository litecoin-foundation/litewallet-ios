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


class SendSwiftUIViewModel: ObservableObject {
    
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
//    var didResolveUDAddress: ((String) -> Void)?
//
//    var shouldClearAddressField: (() -> Void)?
//
//    var didFailToResolve: ((String) -> Void)?
    
    //MARK: - Private Variables
//    private var ltcAddress = ""
//    private var dateFormatter: DateFormatter? {
//
//        didSet {
//            dateFormatter = DateFormatter()
//            dateFormatter?.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        }
//    }
    
    init() { }
    
     
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


