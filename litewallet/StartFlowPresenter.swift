import UIKit
import SwiftUI

class StartFlowPresenter: Subscriber {
	// MARK: - Public

	// MARK: - Private

	private let store: Store
	private let rootViewController: UIViewController
	private var navigationController: ModalNavigationController?
	private let navigationControllerDelegate: StartNavigationDelegate
	private let walletManager: WalletManager
	private var loginViewController: UIViewController?
	private let loginTransitionDelegate = LoginTransitionDelegate()

	init(store: Store, walletManager: WalletManager, rootViewController: UIViewController) {
		self.store = store
		self.walletManager = walletManager
		self.rootViewController = rootViewController
		navigationControllerDelegate = StartNavigationDelegate(store: store)
		addSubscriptions()
	}

	private func addSubscriptions() {
		store.subscribe(self,
		                selector: { $0.isStartFlowVisible != $1.isStartFlowVisible },
		                callback: { self.handleStartFlowChange(state: $0) })
		store.lazySubscribe(self,
		                    selector: { $0.isLoginRequired != $1.isLoginRequired },
		                    callback: { self.handleLoginRequiredChange(state: $0) })
		store.subscribe(self, name: .lock,
		                callback: { _ in
		                	Task { @MainActor in
		                		self.presentLoginFlow(isPresentedForLock: true)
		                	}
		                })
	}

	private func handleStartFlowChange(state: ReduxState) {
		if state.isStartFlowVisible {
			guardProtected(queue: DispatchQueue.main) { [weak self] in
				self?.presentStartFlow()
			}
		} else {
			dismissStartFlow()
		}
	}

	private func handleLoginRequiredChange(state: ReduxState) {
		if state.isLoginRequired {
			presentLoginFlow(isPresentedForLock: false)
		} else {
			dismissLoginFlow()
		}
	}

	// MARK: - SwiftUI Start Flow

	private func presentStartFlow() {
		/// DOC: This is a legacy path for iPad users since SwiftUI doesnt gracefully handle presentations like iPhone
		if UIDevice.current.userInterfaceIdiom == .pad {
			let startViewController = StartViewController(store: store,
			                                              didTapCreate: { [weak self] in
			                                              	self?.pushPinCreationViewControllerForNewWallet()
			                                              },
			                                              didTapRecover: { [weak self] in
			                                              	guard let myself = self else { return }
			                                              	let recoverIntro = RecoverWalletIntroViewController(didTapNext: myself.pushRecoverWalletView)
			                                              	myself.navigationController?.setClearNavbar()
			                                              	myself.navigationController?.modalPresentationStyle = .fullScreen
			                                              	myself.navigationController?.setNavigationBarHidden(false, animated: false)
			                                              	myself.navigationController?.pushViewController(recoverIntro, animated: true)
			                                              })

			navigationController = ModalNavigationController(rootViewController: startViewController)
			navigationController?.delegate = navigationControllerDelegate
			navigationController?.modalPresentationStyle = .fullScreen
		} else {
			let startHostingController = StartHostingController(store: store,
			                                                    walletManager: walletManager)

			startHostingController.viewModel.userWantsToCreate {
				self.pushPinCreationViewControllerForNewWallet()
			}

			startHostingController.viewModel.userWantsToRecover {
				let recoverIntro = RecoverWalletIntroViewController(didTapNext: self.pushRecoverWalletView)
				self.navigationController?.setClearNavbar()
				self.navigationController?.modalPresentationStyle = .fullScreen
				self.navigationController?.setNavigationBarHidden(false, animated: false)
				self.navigationController?.pushViewController(recoverIntro, animated: true)
			}

			navigationController = ModalNavigationController(rootViewController: startHostingController)
			navigationController?.delegate = navigationControllerDelegate
			navigationController?.modalPresentationStyle = .fullScreen
		}

		if let startFlow = navigationController {
			startFlow.setNavigationBarHidden(true, animated: false)
			rootViewController.present(startFlow, animated: false, completion: nil)
		}
	}

	private var pushRecoverWalletView: () -> Void {
		return { [weak self] in
			guard let myself = self else { return }
			let recoverWalletViewController = EnterPhraseViewController(store: myself.store, walletManager: myself.walletManager, reason: .setSeed(myself.pushPinCreationViewForRecoveredWallet))
			myself.navigationController?.pushViewController(recoverWalletViewController, animated: true)
		}
	}

	private func pushPinCreationViewControllerForNewWallet() {
		// Show deprecation screen instead of allowing wallet creation
		let deprecationViewController = WalletDeprecationHostingController()
		
		deprecationViewController.didTapGetNexus = { [weak self] in
			self?.handleGetNexusWallet()
		}
		
		deprecationViewController.didTapGoBack = { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		}
		
		navigationController?.setNavigationBarHidden(true, animated: false)
		navigationController?.pushViewController(deprecationViewController, animated: true)
	}
	
	private func handleGetNexusWallet() {
		// Try to open the App Store link for Nexus Wallet
		if let url = URL(string: "https://apps.apple.com/us/app/nexus-wallet-for-litecoin/id6738978436") {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
	}

	private var pushPinCreationViewForRecoveredWallet: (String) -> Void {
		return { [weak self] phrase in
			guard let myself = self else { return }
			let pinCreationView = UpdatePinViewController(store: myself.store, walletManager: myself.walletManager, type: .creationWithPhrase, showsBackButton: false, phrase: phrase)
			pinCreationView.setPinSuccess = { [weak self] _ in
				DispatchQueue.walletQueue.async {
					self?.walletManager.peerManager?.connect()
					DispatchQueue.main.async {
						self?.store.trigger(name: .didCreateOrRecoverWallet)
					}
				}
			}
			myself.navigationController?.pushViewController(pinCreationView, animated: true)
		}
	}

	private func pushStartPaperPhraseCreationViewController(pin: String) {
		let paperPhraseViewController = StartPaperPhraseViewController(store: store, callback: { [weak self] in
			self?.pushWritePaperPhraseViewController(pin: pin)
		})
		paperPhraseViewController.title = S.SecurityCenter.Cells.paperKeyTitle.localize()
		paperPhraseViewController.navigationItem.setHidesBackButton(true, animated: false)
		paperPhraseViewController.hideCloseNavigationItem() // Forces user to confirm paper-key

		navigationController?.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white,
			NSAttributedString.Key.font: UIFont.customBold(size: 17.0),
		]
		navigationController?.pushViewController(paperPhraseViewController, animated: true)
	}

	private func pushWritePaperPhraseViewController(pin: String) {
		let writeViewController = WritePaperPhraseViewController(store: store, walletManager: walletManager, pin: pin, callback: { [weak self] in
			self?.pushConfirmPaperPhraseViewController(pin: pin)
		})
		writeViewController.title = S.SecurityCenter.Cells.paperKeyTitle.localize()
		writeViewController.hideCloseNavigationItem()
		navigationController?.pushViewController(writeViewController, animated: true)
	}

	private func pushConfirmPaperPhraseViewController(pin: String) {
		let confirmVC = UIStoryboard(name: "Phrase", bundle: nil).instantiateViewController(withIdentifier: "ConfirmPaperPhraseViewController") as? ConfirmPaperPhraseViewController
		confirmVC?.store = store
		confirmVC?.walletManager = walletManager
		confirmVC?.pin = pin
		confirmVC?.didCompleteConfirmation = { [weak self] in
			guard let myself = self else { return }
			myself.store.perform(action: SimpleReduxAlert.Show(.paperKeySet(callback: {
				self?.store.perform(action: HideStartFlow())
			})))
		}
		navigationController?.navigationBar.tintColor = .white
		if let confirmVC = confirmVC {
			navigationController?.pushViewController(confirmVC, animated: true)
		}
	}

	private func presentLoginFlow(isPresentedForLock: Bool) {
		let loginView = LoginViewController(store: store, isPresentedForLock: isPresentedForLock, walletManager: walletManager)
		if isPresentedForLock {
			loginView.shouldSelfDismiss = true
		}
		loginView.transitioningDelegate = loginTransitionDelegate
		loginView.modalPresentationStyle = .overFullScreen
		loginView.modalPresentationCapturesStatusBarAppearance = true
		loginViewController = loginView
		rootViewController.present(loginView, animated: false, completion: nil)
	}

	private func handleWalletCreationError() {
		let alert = UIAlertController(title: S.LitewalletAlert.error.localize(), message: "Could not create wallet", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: S.Button.ok.localize(), style: .default, handler: nil))
		navigationController?.present(alert, animated: true, completion: nil)
	}

	private func dismissStartFlow() {
		navigationController?.dismiss(animated: true) { [weak self] in
			self?.navigationController = nil
		}
	}

	private func dismissLoginFlow() {
		loginViewController?.dismiss(animated: true, completion: { [weak self] in
			self?.loginViewController = nil
		})
	}
}

// MARK: - Wallet Deprecation View

struct WalletDeprecationView: View {
    let buttonFont: Font = .custom("Satoshi-Bold", size: 18.0)
    let titleFont: Font = .custom("Satoshi-Bold", size: 24.0)
    let bodyFont: Font = .custom("Satoshi-Medium", size: 16.0)
    let benefitFont: Font = .custom("Satoshi-Medium", size: 15.0)
    
    var didTapGetNexus: (() -> Void)?
    var didTapGoBack: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Color(hex: "0070F0").ignoresSafeArea(.all)
                
                VStack {
                    // Scrollable content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header Section
                            VStack(spacing: 16) {
                                // Warning Icon
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)
                                
                                // Title
                                Text("App Deprecation Notice")
                                    .font(.custom("Satoshi-Bold", size: 24))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                            
                            // Gap between title and main message
                            Spacer()
                                .frame(height: 30)
                            
                            // Main Message
                            Text("Litewallet is no longer being maintained. Please use Nexus Wallet for Litecoin instead.")
                                .font(bodyFont)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            // Gap between main message and benefits
                            Spacer()
                                .frame(height: 40)
                            
                            // Benefits Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Why Choose Nexus Wallet?")
                                    .font(.custom("Satoshi-Bold", size: 20))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    BenefitRow(
                                        icon: "dollarsign.circle.fill",
                                        title: "Lower Fees",
                                        description: "Enjoy reduced fees when buying, selling, and sending Litecoin"
                                    )
                                    
                                    BenefitRow(
                                        icon: "speedometer",
                                        title: "Faster Transactions",
                                        description: "Optimized transaction processing for quicker confirmations"
                                    )
                                    
                                    BenefitRow(
                                        icon: "person.2.fill",
                                        title: "Active Support",
                                        description: "Dedicated team providing ongoing updates and customer support"
                                    )
                                    
                                    BenefitRow(
                                        icon: "star.fill",
                                        title: "Modern Experience",
                                        description: "Intuitive interface designed for both beginners and experts"
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Extra spacing to push buttons to bottom
                            Spacer()
                                .frame(minHeight: 60)
                        }
                    }
                    
                    // Pinned buttons at bottom
                    VStack(spacing: 16) {
                        // Get Nexus Wallet Button (Primary)
                        Button(action: {
                            didTapGetNexus?()
                        }) {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: width * 0.9, height: 50)
                                .foregroundColor(.white)
                                .overlay(
                                    Text("Get Nexus Wallet")
                                        .font(buttonFont)
                                        .foregroundColor(Color(hex: "0070F0"))
                                )
                        }
                        
                        // Go Back Button (Secondary)
                        Button(action: {
                            didTapGoBack?()
                        }) {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: width * 0.9, height: 50)
                                .foregroundColor(.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white, lineWidth: 1.5)
                                )
                                .overlay(
                                    Text("Go Back")
                                        .font(buttonFont)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Satoshi-Bold", size: 16))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.custom("Satoshi-Medium", size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

// MARK: - Hosting Controller

class WalletDeprecationHostingController: UIViewController {
    
    private var hostingController: UIHostingController<WalletDeprecationView>
    var didTapGetNexus: (() -> Void)?
    var didTapGoBack: (() -> Void)?
    
    init() {
        let deprecationView = WalletDeprecationView()
        hostingController = UIHostingController(rootView: deprecationView)
        super.init(nibName: nil, bundle: nil)
        
        // Set up callbacks
        updateCallbacks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // No title for cleaner look
        view.backgroundColor = UIColor(red: 0.0, green: 0.44, blue: 0.94, alpha: 1.0) // #0070F0
        
        // Add hosting controller as child
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set up constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        updateCallbacks()
    }
    
    private func updateCallbacks() {
        var deprecationView = hostingController.rootView
        deprecationView.didTapGetNexus = { [weak self] in
            self?.didTapGetNexus?()
        }
        deprecationView.didTapGoBack = { [weak self] in
            self?.didTapGoBack?()
        }
        hostingController.rootView = deprecationView
    }
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
