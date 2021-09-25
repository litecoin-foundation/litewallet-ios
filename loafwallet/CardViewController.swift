//
//  CardViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/22/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation

import UIKit
import SwiftUI
 

/// A container for a CardView - SwiftUI
class CardViewController: UIViewController {
    
    var viewModel: CardViewModel?
    
    var cardLoggedInView: CardLoggedInView?
 
    var cardView: CardView?
    
    var walletManager: WalletManager?
    
    var store: Store?
 
    var parentFrame: CGRect?
    
    var swiftUIContainerView = UIHostingController(rootView: AnyView(EmptyView()))
    
    var notificationToken: NSObjectProtocol?
    
    private func updateLoginStatusFromViewModel() {
        
        guard let viewModel = self.viewModel else {
            NSLog("ERROR: CardViewModel not loaded")
            LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR) 
            return
        }
     
        // Verifies the stack has only one VC and it is the UIHostingController
        DispatchQueue.main.async {
            if self.childViewControllers.count == 1,
               ((self.childViewControllers.first?.isKind(of: UIHostingController<AnyView>.self)) != nil) {
                self.swiftUIContainerView.willMove(toParent: nil)
                self.swiftUIContainerView.removeFromParentViewController()
                self.swiftUIContainerView.view.removeFromSuperview()
            }
            
            if viewModel.isLoggedIn {
                self.cardLoggedInView = CardLoggedInView(viewModel: viewModel,
                                                         twoFactor: viewModel.cardTwoFactor)
                self.swiftUIContainerView = UIHostingController(rootView: AnyView(self.cardLoggedInView))
            } else {
                self.cardView = CardView(viewModel: viewModel)
                self.swiftUIContainerView = UIHostingController(rootView: AnyView(self.cardView))
            }
            
            //Constraint the view to Tab container
            if let size = self.parentFrame?.size {
                self.swiftUIContainerView.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            }
            
            self.addChildViewController(self.swiftUIContainerView)
            self.view.addSubview(self.swiftUIContainerView.view)
            self.swiftUIContainerView.didMove(toParent: self)
        }
    }
         
     override func viewDidLoad() {
        
        // Preparation values for the Card view model
        guard let walletManager = self.walletManager,
              let store = self.store else {
            
            LWAnalytics.logEventWithParameters(itemName: ._20200112_ERR)
            
            return
        }
          
        self.viewModel = CardViewModel(walletManager: walletManager,
                                       store: store)
         
        self.updateLoginStatusFromViewModel()
 
        // Listens for Login notification and updates the CardView
        notificationToken = NotificationCenter.default
        .addObserver(forName: NSNotification.Name.LitecoinCardLoginNotification,
                     object: nil,
                     queue: nil) { _ in
            
            LWAnalytics.logEventWithParameters(itemName: ._20210804_TAULI)

            self.viewModel?.fetchCardWalletDetails {
                LWAnalytics.logEventWithParameters(itemName: ._20210804_TAWDS)
            }
			
            self.updateLoginStatusFromViewModel()
        }
         
        // Listens for Logout notification and updates the CardView
        notificationToken = NotificationCenter.default
        .addObserver(forName: NSNotification.Name.LitecoinCardLogoutNotification,
                     object: nil,
                     queue: nil) { _ in
            
            LWAnalytics.logEventWithParameters(itemName: ._20210804_TAULO)
            
            self.updateLoginStatusFromViewModel()
        }
    }
     
}
    
   
