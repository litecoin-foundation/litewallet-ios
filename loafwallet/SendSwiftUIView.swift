//
//  SendSwiftUIView.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/3/22.
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import UIKit


class SendUIHostingController : UIHostingController<SendSwiftUIView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SendSwiftUIView())
    }
}

struct SendSwiftUIView: View {
    var body: some View {
        GeometryReader { geometry in
             
                VStack {
                    Text("New Litewallet SEND")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                    Spacer()
                    Text("STUFF")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                    Text("DRAFT").font(.title)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                    Text("STUFF")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                    Text("MORE STUFF")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                    Spacer()
                    Button {
                        ///do something
                    } label: {
                        Text("SEND").foregroundColor(Color.liteWalletBlue)
                    }.padding()
                }.background(Color.red)
        }
    }
}

struct SendSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SendSwiftUIView()
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
