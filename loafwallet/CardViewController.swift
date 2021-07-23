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
    
    var litewalletBalance: Amount?
    
    var walletManager: WalletManager?
 
    var parentFrame: CGRect?
    
    var swiftUIContainerView = UIHostingController(rootView: AnyView(EmptyView()))
    
    var notificationToken: NSObjectProtocol?
    
    private func updateLoginStatusFromViewModel() {
        
        guard let viewModel = self.viewModel else {
            NSLog("ERROR: CardViewModel not loaded")
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
                self.cardLoggedInView = CardLoggedInView(viewModel: viewModel)
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
        
        guard let balance = self.litewalletBalance else {
            return
        }
        
        guard let walletManager = self.walletManager else {
            return
        }
         
        self.viewModel = CardViewModel(litewalletAmount: balance,
                                       walletManager: walletManager)
         
        self.updateLoginStatusFromViewModel()
 
       // Listens for Login notification and updates the CardView
        notificationToken = NotificationCenter.default
        .addObserver(forName: NSNotification.Name.LitecoinCardLoginNotification,
                     object: nil,
                     queue: nil) { _ in
            
            self.viewModel?.fetchCardWalletDetails {
                print("Logged in updated wallet values")
            }
			
            self.updateLoginStatusFromViewModel()
        }
         
        // Listens for Logout notification and updates the CardView
        notificationToken = NotificationCenter.default
        .addObserver(forName: NSNotification.Name.LitecoinCardLogoutNotification,
                     object: nil,
                     queue: nil) { _ in
            self.updateLoginStatusFromViewModel()
        }
        
        // Listens for 2FA Enrollment notification and updates the CardView
        notificationToken = NotificationCenter.default
            .addObserver(forName: NSNotification.Name.LitecoinCard2FANotification,
                         object: nil,
                         queue: nil) { _ in
               
            }
    }
     
}
    
   
