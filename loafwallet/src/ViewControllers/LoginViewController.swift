//
//  LoginViewController.swift
//  breadwallet
//  Modified by Kerry Washington
//  Created by Adrian Corscadden on 2017-01-19.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import UIKit
import SwiftUI
import LocalAuthentication
import FirebaseCrashlytics

private let squareButtonSize: CGFloat = 32.0
private let headerHeight: CGFloat = 110

protocol LoginViewControllerDelegate {
    func didUnlockLogin()
}

class LoginViewController : UIViewController, Subscriber, Trackable {

    //MARK: - Public
    var walletManager: WalletManager? {
        didSet {
            guard walletManager != nil else { return }
            pinView = PinView(style: .login, length: store.state.pinLength)
        }
    }
    var shouldSelfDismiss = false
    
    init(store: Store, isPresentedForLock: Bool, walletManager: WalletManager? = nil) {
        self.store = store
        self.walletManager = walletManager
        self.isPresentedForLock = isPresentedForLock
        self.disabledView = WalletDisabledView(store: store)
        if walletManager != nil {
            self.pinView = PinView(style: .login, length: store.state.pinLength)
        }
        
        let viewModel = LockScreenHeaderViewModel(store: self.store)
        self.headerView = UIHostingController(rootView: LockScreenHeaderView(viewModel: viewModel))
    
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        store.unsubscribe(self)
    }

    //MARK: - Private
    private let store: Store
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .liteWalletBlue
        return view
    }()
    
    private let headerView: UIHostingController<LockScreenHeaderView>

    private let pinPadViewController = PinPadViewController(style: .clear, keyboardType: .pinPad, maxDigits: 0)
    private let pinViewContainer = UIView()
    private var pinView: PinView?
    private let isPresentedForLock: Bool
    private let disabledView: WalletDisabledView
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .large)
    private let wipeBannerButton = UIButton()
    var delegate: LoginViewControllerDelegate?
    
    private var logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "coinBlueWhite"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let biometricsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(LAContext.biometricType() == .face ? #imageLiteral(resourceName: "FaceId") : #imageLiteral(resourceName: "TouchId"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = squareButtonSize/2.0
        button.layer.masksToBounds = true
        button.accessibilityLabel = LAContext.biometricType() == .face ? S.UnlockScreen.faceIdText : S.UnlockScreen.touchIdText
        return button
    }()
    
    private let showLTCAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "genericqricon"), for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    
    private let enterPINLabel = UILabel(font: .barlowBold(size: 17), color: .white)
    private var pinPadBottom: NSLayoutConstraint?
    private var topControlTop: NSLayoutConstraint?
    private var unlockTimer: Timer?
    private var pinPadBackground = UIView()
    private var hasAttemptedToShowBiometrics = false
    private let lockedOverlay = UIVisualEffectView()
    private var isResetting = false
    private let versionLabel = UILabel(font: .barlowLight(size: 10), color: .white)
    private var isWalletEmpty = false
  
    override func viewDidLoad() {
        self.checkWalletBalance()
        addSubviews()
        addConstraints()
        addBiometricsButton()
        
        addPinPadCallback()
        if pinView != nil {
            addPinView()
        }
        addWipeWalletView()
        disabledView.didTapReset = { [weak self] in
            guard let store = self?.store else { return }
            guard let walletManager = self?.walletManager else { return }
            self?.isResetting = true
            let nc = UINavigationController()
            let recover = EnterPhraseViewController(store: store, walletManager: walletManager, reason: .validateForResettingPin({ phrase in
                let updatePin = UpdatePinViewController(store: store, walletManager: walletManager, type: .creationWithPhrase, showsBackButton: false, phrase: phrase)
                nc.pushViewController(updatePin, animated: true)
                updatePin.resetFromDisabledWillSucceed = {
                    self?.disabledView.isHidden = true
                }
                updatePin.resetFromDisabledSuccess = {
                    self?.authenticationSucceded()
                    LWAnalytics.logEventWithParameters(itemName: ._20200217_DUWP)
                }
            }))
            recover.addCloseNavigationItem()
            nc.viewControllers = [recover]
            nc.navigationBar.tintColor = .darkText
            nc.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.darkText,
                NSAttributedString.Key.font: UIFont.customBold(size: 17.0)
            ]
            nc.setClearNavbar()
            nc.navigationBar.isTranslucent = false
            nc.navigationBar.barTintColor = .whiteTint
            nc.viewControllers = [recover]
            self?.present(nc, animated: true, completion: nil)
        }
        store.subscribe(self, name: .loginFromSend, callback: {_ in
            self.authenticationSucceded()
        })
      
        NotificationCenter.default.addObserver(forName: .WalletBalanceChangedNotification,
                                               object: nil, queue: nil, using: { (note) in
          
            if let balance = note.userInfo?["balance"] as? Int {
              
              if balance == 0 {
                self.isWalletEmpty = true
              } else {
                self.isWalletEmpty = false
              }
              self.addWipeWalletView()
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard UIApplication.shared.applicationState != .background else { return }
        if shouldUseBiometrics && !hasAttemptedToShowBiometrics && !isPresentedForLock && UserDefaults.hasShownWelcome {
            hasAttemptedToShowBiometrics = true
            biometricsTapped()
        }
        
        addShowAddressButton()
        
        if !isResetting {
            lockIfNeeded()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unlockTimer?.invalidate()
    }

    private func addPinView() {
        guard let pinView = pinView else { return }
        pinViewContainer.addSubview(pinView)
        
        pinView.constrain([
                            pinView.centerYAnchor.constraint(equalTo: pinPadViewController.view.topAnchor, constant: -40),
                            pinView.centerXAnchor.constraint(equalTo: pinViewContainer.centerXAnchor),
                            pinView.widthAnchor.constraint(equalToConstant: pinView.width),
                            pinView.heightAnchor.constraint(equalToConstant: pinView.itemSize) ])
        
        enterPINLabel.constrain([
            enterPINLabel.topAnchor.constraint(equalTo: pinView.topAnchor, constant: -40),
            enterPINLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor) ])
       
        logo.constrain([
            logo.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.constraint(.height, constant: 70),
            logo.constraint(.width, constant: 70) ])
        
    }

    private func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(headerView.view)
        view.addSubview(pinViewContainer)
        view.addSubview(logo)
        view.addSubview(versionLabel)
        view.addSubview(enterPINLabel)

        pinPadBackground.backgroundColor = .clear
        if walletManager != nil {
            view.addSubview(pinPadBackground)
        } else {
            view.addSubview(activityView)
        }
    }

    private func addConstraints() {
        backgroundView.constrain(toSuperviewEdges: nil)
        headerView.view.constrain([
                                    headerView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                    headerView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                    headerView.view.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                                    headerView.view.heightAnchor.constraint(equalToConstant: headerHeight)])

        if walletManager != nil {
            addChildViewController(pinPadViewController, layout: {
                pinPadBottom = pinPadViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
                pinPadViewController.view.constrain([
                    pinPadViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    pinPadViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    pinPadBottom,
                    pinPadViewController.view.heightAnchor.constraint(equalToConstant: pinPadViewController.height) ])
            })
        }
        pinViewContainer.constrain(toSuperviewEdges: nil)

        versionLabel.constrain([
            versionLabel.constraint(.top, toView: view, constant: 30),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            versionLabel.widthAnchor.constraint(equalToConstant: 120.0),
            versionLabel.heightAnchor.constraint(equalToConstant: 44.0) ])
        
        if walletManager != nil {
            pinPadBackground.constrain([
                pinPadBackground.leadingAnchor.constraint(equalTo: pinPadViewController.view.leadingAnchor),
                pinPadBackground.trailingAnchor.constraint(equalTo: pinPadViewController.view.trailingAnchor),
                pinPadBackground.topAnchor.constraint(equalTo: pinPadViewController.view.topAnchor),
                pinPadBackground.bottomAnchor.constraint(equalTo: pinPadViewController.view.bottomAnchor) ])
        } else {
            activityView.constrain([
                activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20.0) ])
            activityView.startAnimating()
        }
      
        enterPINLabel.text = S.UnlockScreen.enterPIN
        versionLabel.text = AppVersion.string
        versionLabel.textAlignment = .right
    }
  
    private func deviceTopConstraintConstant() -> CGFloat {
      let screenHeight = E.screenHeight
      var constant  = 0.0
      if screenHeight <= 640 {
        constant = 35
      } else if screenHeight > 640 && screenHeight < 800 {
        constant = 45
      } else {
        constant = 55
      }
      return C.padding[1] + CGFloat(constant)
    }
    private func addWipeWalletView() {
        
        if isWalletEmpty {
            view.addSubview(wipeBannerButton)
            wipeBannerButton.translatesAutoresizingMaskIntoConstraints = true
            wipeBannerButton.backgroundColor = .clear
            wipeBannerButton.adjustsImageWhenHighlighted = true
            
            wipeBannerButton.constrain([
               wipeBannerButton.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant: 0),
                wipeBannerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                wipeBannerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                wipeBannerButton.heightAnchor.constraint(equalToConstant: 60)])
            
            wipeBannerButton.setTitle(S.WipeWallet.emptyWallet, for: .normal)
            wipeBannerButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            wipeBannerButton.titleLabel?.font = .barlowSemiBold(size: 17)
            wipeBannerButton.addTarget(self, action: #selector(wipeTapped), for: .touchUpInside)
            
        } else {
            wipeBannerButton.removeFromSuperview()
        }
        
    }
    private func addBiometricsButton() {
        guard shouldUseBiometrics else { return }
        view.addSubview(biometricsButton)
        biometricsButton.addTarget(self, action: #selector(biometricsTapped), for: .touchUpInside)
        biometricsButton.constrain([
                                    biometricsButton.widthAnchor.constraint(equalToConstant: squareButtonSize),
                                    biometricsButton.heightAnchor.constraint(equalToConstant: squareButtonSize),
                                    biometricsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.padding[2]),
                                    biometricsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight + C.padding[2]) ])
    }
    
    private func addShowAddressButton() {
        view.addSubview(showLTCAddressButton)
        showLTCAddressButton.addTarget(self, action: #selector(showLTCAddress), for: .touchUpInside)
        showLTCAddressButton.constrain([
                                        showLTCAddressButton.widthAnchor.constraint(equalToConstant: squareButtonSize),
                                        showLTCAddressButton.heightAnchor.constraint(equalToConstant: squareButtonSize),
                                        showLTCAddressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.padding[2]),
                                        showLTCAddressButton.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight + C.padding[2]) ])
    }
    
    
  
    private func addPinPadCallback() {
        pinPadViewController.ouputDidUpdate = { [weak self] pin in
            guard let myself = self else { return }
            guard let pinView = self?.pinView else { return }
            let attemptLength = pin.utf8.count
            pinView.fill(attemptLength)
            self?.pinPadViewController.isAppendingDisabled = attemptLength < myself.store.state.pinLength ? false : true
            if attemptLength == myself.store.state.pinLength {
                self?.authenticate(pin: pin)
            }
        }
    }
  
    private func checkWalletBalance() {
      if let wallet = self.walletManager?.wallet {
        if wallet.balance == 0 {
          isWalletEmpty = true
        } else {
          isWalletEmpty = false
        }
      }
    }

    private func authenticate(pin: String) {
        guard let walletManager = walletManager else { return }
        guard !E.isScreenshots else { return authenticationSucceded() }
        guard walletManager.authenticate(pin: pin) else { return authenticationFailed() }
        authenticationSucceded()
        LWAnalytics.logEventWithParameters(itemName: ._20200217_DUWP)
    }

    private func authenticationSucceded() {
        saveEvent("login.success")
        let label = UILabel(font: enterPINLabel.font)
        label.textColor = .white
        label.text = S.UnlockScreen.unlocked
        let lock = UIImageView(image: #imageLiteral(resourceName: "unlock"))
        lock.transform = .init(scaleX: 0.6, y: 0.6)
         
        if let _pinView = self.pinView {
            enterPINLabel.removeFromSuperview()
            _pinView.removeFromSuperview()
        }
        
        view.addSubview(label)
        view.addSubview(lock)

        label.constrain([
            label.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -C.padding[1]),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor) ])
        lock.constrain([
            lock.topAnchor.constraint(equalTo: label.bottomAnchor, constant: C.padding[1]),
            lock.centerXAnchor.constraint(equalTo: label.centerXAnchor) ])
        view.layoutIfNeeded()
  
        self.logo.alpha = 0.0
        self.wipeBannerButton.alpha = 1.0
        
        UIView.spring(0.6, delay: 0.4, animations: {
            self.pinPadBottom?.constant = self.pinPadViewController.height
            self.topControlTop?.constant = -100.0
             
            lock.alpha = 0.0
            label.alpha = 0.0
            self.wipeBannerButton.alpha = 0.0
            self.enterPINLabel.alpha = 0.0
            self.pinView?.alpha = 0.0
            
            self.view.layoutIfNeeded()
        }) { completion in
            self.delegate?.didUnlockLogin()
            if self.shouldSelfDismiss {
                self.dismiss(animated: true, completion: nil)
            }
            self.store.perform(action: LoginSuccess())
            self.store.trigger(name: .showStatusBar)
        }
    }

    private func authenticationFailed() {
        saveEvent("login.failed")
        guard let pinView = pinView else { return }
        pinPadViewController.view.isUserInteractionEnabled = false
        pinView.shake { [weak self] in
            self?.pinPadViewController.view.isUserInteractionEnabled = true
        }
        pinPadViewController.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + pinView.shakeDuration) { [weak self] in
            pinView.fill(0)
            self?.lockIfNeeded()
        }
    }

    private var shouldUseBiometrics: Bool {
        guard let walletManager = self.walletManager else { return false }
        return LAContext.canUseBiometrics && !walletManager.pinLoginRequired && store.state.isBiometricsEnabled
    }

    @objc func biometricsTapped() {
        guard !isWalletDisabled else { return }
        walletManager?.authenticate(biometricsPrompt: S.UnlockScreen.touchIdPrompt, completion: { result in
            if result == .success {
                self.authenticationSucceded()
                LWAnalytics.logEventWithParameters(itemName: ._20200217_DUWB)
            }
        })
    }
    
    @objc func showLTCAddress() {
        guard !isWalletDisabled else { return }
        store.perform(action: RootModalActions.Present(modal: .loginAddress))
    }
    
 
    @objc func wipeTapped() {
      store.perform(action: RootModalActions.Present(modal: .wipeEmptyWallet))
    }

    private func lockIfNeeded() {
        if let disabledUntil = walletManager?.walletDisabledUntil {
            let now = Date().timeIntervalSince1970
            if disabledUntil > now {
                saveEvent("login.locked")
                let disabledUntilDate = Date(timeIntervalSince1970: disabledUntil)
                let unlockInterval = disabledUntil - now
                let df = DateFormatter()
                df.setLocalizedDateFormatFromTemplate(unlockInterval > C.secondsInDay ? "h:mm:ss a MMM d, yyy" : "h:mm:ss a")

                disabledView.setTimeLabel(string: String(format: S.UnlockScreen.disabled, df.string(from: disabledUntilDate)))

                pinPadViewController.view.isUserInteractionEnabled = false
                unlockTimer?.invalidate()
                unlockTimer = Timer.scheduledTimer(timeInterval: unlockInterval, target: self, selector: #selector(LoginViewController.unlock), userInfo: nil, repeats: false)

                if disabledView.superview == nil {
                    view.addSubview(disabledView)
                    setNeedsStatusBarAppearanceUpdate()
                    disabledView.constrain(toSuperviewEdges: nil)
                    disabledView.show()
                }
            } else {
                pinPadViewController.view.isUserInteractionEnabled = true
                disabledView.hide { [weak self] in
                    self?.disabledView.removeFromSuperview()
                    self?.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }

    private var isWalletDisabled: Bool {
        guard let walletManager = walletManager else { return false }
        let now = Date().timeIntervalSince1970
        return walletManager.walletDisabledUntil > now
    }

    @objc private func unlock() {
        saveEvent("login.unlocked")
        self.delegate?.didUnlockLogin()
        enterPINLabel.pushNewText(S.UnlockScreen.enterPIN)
        pinPadViewController.view.isUserInteractionEnabled = true
        unlockTimer = nil
        disabledView.hide { [weak self] in
            self?.disabledView.removeFromSuperview()
            self?.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if disabledView.superview == nil {
            return .lightContent
        } else {
            return .default
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

