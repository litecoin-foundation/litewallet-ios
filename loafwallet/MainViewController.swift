//
//  MainViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import BRCore
import MachO
import SwiftUI

class MainViewController : UIViewController, Subscriber, LoginViewControllerDelegate {

    //MARK: - Private
    private let store: Store
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var isLoginRequired = false
    private let loginView: LoginViewController
    private let tempLoginView: LoginViewController
    private let loginTransitionDelegate = LoginTransitionDelegate()
    private let welcomeTransitingDelegate = TransitioningDelegate()
    
    private var loadingTimer: Timer?
    private var didEndLoading = false
   
    var walletManager: WalletManager? {
        didSet {
            guard let walletManager = walletManager else { return }
            if !walletManager.noWallet {
                loginView.walletManager = walletManager
                loginView.transitioningDelegate = loginTransitionDelegate
                loginView.modalPresentationStyle = .overFullScreen
                loginView.modalPresentationCapturesStatusBarAppearance = true
                loginView.shouldSelfDismiss = true
                present(loginView, animated: false, completion: {
                    self.tempLoginView.remove()
                    self.attemptShowWelcomeView()
                })
            }
        }
    }
   
    init(store: Store) {
        self.store = store
        self.loginView = LoginViewController(store: store, isPresentedForLock: false)
        self.tempLoginView = LoginViewController(store: store, isPresentedForLock: false)
        super.init(nibName: nil, bundle: nil)
    }
   
    override func viewDidLoad() {
        
        self.view.backgroundColor = .liteWalletBlue
        
        self.navigationController?.navigationBar.tintColor = .liteWalletBlue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkText,
            NSAttributedString.Key.font: UIFont.customBold(size: 17.0)
        ]
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .liteWalletBlue
        self.loginView.delegate = self
       
        // detect jailbreak so we can throw up an idiot warning, in viewDidLoad so it can't easily be swizzled out
        if !E.isSimulator {
            var s = stat()
            var isJailbroken = (stat("/bin/sh", &s) == 0) ? true : false
            for i in 0..<_dyld_image_count() {
                guard !isJailbroken else { break }
                // some anti-jailbreak detection tools re-sandbox apps, so do a secondary check for any MobileSubstrate dyld images
                if strstr(_dyld_get_image_name(i), "MobileSubstrate") != nil {
                    isJailbroken = true
                }
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil) { (notification) in
                self.showJailbreakWarnings(isJailbroken: isJailbroken)
            }
        }
       
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { _ in
            if UserDefaults.writePaperPhraseDate != nil {
            }
        }
        
        addSubscriptions()
        addAppLifecycleNotificationEvents()
        addTemporaryStartupViews()
    }
   
    func didUnlockLogin() {
          
        if UserDefaults.userIsInUSA {
            guard let usaVC = UIStoryboard.init(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "TabBarViewController")
                        as? TabBarViewController else {
                
                NSLog("TabBarViewController not intialized")
                return
            }
            
            usaVC.store = self.store
            usaVC.walletManager = walletManager
            
            addChildViewController(usaVC, layout:{
                usaVC.view.constrain(toSuperviewEdges: nil)
                usaVC.view.alpha = 0
                usaVC.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.1,
                           options: .transitionCrossDissolve,
                           animations: {
                            
                usaVC.view.alpha = 1
                            
            }) { (finished) in
                NSLog(" Ex US MainView Controller presented")
            }
             
        } else {
            
            guard let exUSAVC = UIStoryboard.init(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "NonUSTabBarViewController")
                        as? NonUSTabBarViewController else {
                
                NSLog("NonUSTabBarViewController not intialized")
                return
            }
            
            exUSAVC.store = self.store
            exUSAVC.walletManager = walletManager
            
            addChildViewController(exUSAVC, layout:{
                exUSAVC.view.constrain(toSuperviewEdges: nil)
                exUSAVC.view.alpha = 0
                exUSAVC.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
                exUSAVC.view.alpha = 1
            }) { (finished) in
                NSLog("US MainView Controller presented")
            }
        }
    }

    private func addTemporaryStartupViews() {
        guardProtected(queue: DispatchQueue.main) {
            if !WalletManager.staticNoWallet {
                self.addChildViewController(self.tempLoginView, layout: {
                    self.tempLoginView.view.constrain(toSuperviewEdges: nil)
                })
            } else {
                let startView = StartViewController(store: self.store, didTapCreate: {}, didTapRecover: {})
                self.addChildViewController(startView, layout: {
                    startView.view.constrain(toSuperviewEdges: nil)
                    startView.view.isUserInteractionEnabled = false
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    startView.remove()
                })
            }
        }
    }
    
    private func addSubscriptions() {
       store.subscribe(self, selector: { $0.isLoginRequired != $1.isLoginRequired },
                       callback: { self.isLoginRequired = $0.isLoginRequired
       })
    }
     
    private func addAppLifecycleNotificationEvents() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil) { note in
            UIView.animate(withDuration: 0.1, animations: {
                self.blurView.alpha = 0.0
            }, completion: { _ in
                self.blurView.removeFromSuperview()
            })
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil) { note in
            if !self.isLoginRequired && !self.store.state.isPromptingBiometrics {
                self.blurView.alpha = 1.0
                self.view.addSubview(self.blurView)
                self.blurView.constrain(toSuperviewEdges: nil)
            }
        }
    }
   
    private func showJailbreakWarnings(isJailbroken: Bool) {
        guard isJailbroken else { return }
        let totalSent = walletManager?.wallet?.totalSent ?? 0
        let message = totalSent > 0 ? S.JailbreakWarnings.messageWithBalance : S.JailbreakWarnings.messageWithBalance
        let alert = UIAlertController(title: S.JailbreakWarnings.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: S.JailbreakWarnings.ignore, style: .default, handler: nil))
        if totalSent > 0 {
            alert.addAction(UIAlertAction(title: S.JailbreakWarnings.wipe, style: .default, handler: nil)) //TODO - implement wipe
        } else {
            alert.addAction(UIAlertAction(title: S.JailbreakWarnings.close, style: .default, handler: { _ in
                exit(0)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
   
    private func attemptShowWelcomeView() {
        if !UserDefaults.hasShownWelcome {
            let welcome = WelcomeViewController()
            welcome.transitioningDelegate = welcomeTransitingDelegate
            welcome.modalPresentationStyle = .overFullScreen
            welcome.modalPresentationCapturesStatusBarAppearance = true
            welcomeTransitingDelegate.shouldShowMaskView = false
            loginView.present(welcome, animated: true, completion: nil)
            UserDefaults.hasShownWelcome = true
        }
    }
   
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
