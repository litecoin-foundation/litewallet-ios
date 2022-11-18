import LocalAuthentication
import UIKit

private let headerHeight: CGFloat = 222.0
private let fadeStart: CGFloat = 185.0
private let fadeEnd: CGFloat = 160.0

class SecurityCenterViewController: UIViewController, Subscriber
{
	var didTapPin: (() -> Void)?
	{
		didSet
		{
			pinCell.tap = didTapPin
		}
	}

	var didTapBiometrics: (() -> Void)?
	{
		didSet
		{
			biometricsCell.tap = didTapBiometrics
		}
	}

	var didTapPaperKey: (() -> Void)?
	{
		didSet { paperKeyCell.tap = didTapPaperKey }
	}

	init(store: Store, walletManager: WalletManager)
	{
		self.store = store
		self.walletManager = walletManager
		header = ModalHeaderView(title: S.SecurityCenter.title, style: .light, faqInfo: (store, ArticleIds.securityCenter))

		if #available(iOS 11.0, *)
		{
			shield.tintColor = UIColor(named: "labelTextColor")
			headerBackground.backgroundColor = UIColor(named: "mainColor")
		}

		super.init(nibName: nil, bundle: nil)
	}

	fileprivate var headerBackgroundHeight: NSLayoutConstraint?
	private var headerBackground = UIView()
	private let header: ModalHeaderView
	fileprivate var shield = UIImageView(image: #imageLiteral(resourceName: "shield"))
	private let scrollView = UIScrollView()
	private let info = UILabel(font: .customBody(size: 16.0))
	private let pinCell = SecurityCenterCell(title: S.SecurityCenter.Cells.pinTitle, descriptionText: S.SecurityCenter.Cells.pinDescription)
	private let biometricsCell = SecurityCenterCell(title: LAContext.biometricType() == .face ? S.SecurityCenter.Cells.faceIdTitle : S.SecurityCenter.Cells.touchIdTitle, descriptionText: S.SecurityCenter.Cells.touchIdDescription)
	private let paperKeyCell = SecurityCenterCell(title: S.SecurityCenter.Cells.paperKeyTitle, descriptionText: S.SecurityCenter.Cells.paperKeyDescription)
	private var separator = UIView(color: .secondaryShadow)
	private let store: Store
	private let walletManager: WalletManager
	fileprivate var didViewAppear = false

	deinit
	{
		store.unsubscribe(self)
	}

	override func viewDidLoad()
	{
		setupSubviewProperties()
		addSubviews()
		addConstraints()
	}

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		setPinAndPhraseChecks()
		didViewAppear = false
	}

	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		didViewAppear = true
	}

	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated)
		didViewAppear = false
	}

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return .lightContent
	}

	private func setupSubviewProperties()
	{
		if #available(iOS 11.0, *)
		{
			guard let backgroundColor = UIColor(named: "lfBackgroundColor")
			else
			{
				NSLog("ERROR: Main color")
				return
			}
			view.backgroundColor = backgroundColor
		}
		else
		{
			view.backgroundColor = .white
		}

		header.closeCallback = {
			self.dismiss(animated: true, completion: nil)
		}
		scrollView.alwaysBounceVertical = true
		scrollView.panGestureRecognizer.delaysTouchesBegan = false
		scrollView.delegate = self
		info.text = S.SecurityCenter.info
		info.numberOfLines = 0
		info.lineBreakMode = .byWordWrapping
		header.backgroundColor = .clear

		setPinAndPhraseChecks()
		store.subscribe(self, selector: { $0.isBiometricsEnabled != $1.isBiometricsEnabled }, callback: {
			self.biometricsCell.isCheckHighlighted = $0.isBiometricsEnabled
		})
		store.subscribe(self, selector: { $1.alert == .paperKeySet(callback: {})
		}, callback: { _ in
			self.setPinAndPhraseChecks() // When paper phrase is confirmed, we need to update the check mark status
		})
	}

	private func addSubviews()
	{
		view.addSubview(scrollView)
		scrollView.addSubview(headerBackground)
		headerBackground.addSubview(header)
		headerBackground.addSubview(shield)
		scrollView.addSubview(pinCell)
		scrollView.addSubview(biometricsCell)
		scrollView.addSubview(paperKeyCell)
		scrollView.addSubview(info)
	}

	private func addConstraints()
	{
		scrollView.constrain([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor), scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
		headerBackground.constrain([
			headerBackground.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			headerBackground.topAnchor.constraint(equalTo: view.topAnchor),
			headerBackground.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			headerBackground.widthAnchor.constraint(equalTo: view.widthAnchor),
		])
		headerBackgroundHeight = headerBackground.heightAnchor.constraint(equalToConstant: headerHeight)
		headerBackground.constrain([headerBackgroundHeight])
		header.constrain([
			header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			header.topAnchor.constraint(equalTo: headerBackground.topAnchor, constant: E.isIPhoneX ? 30.0 : 20.0),
			header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			header.heightAnchor.constraint(equalToConstant: C.Sizes.headerHeight),
		])
		shield.constrain([
			shield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			shield.centerYAnchor.constraint(equalTo: headerBackground.centerYAnchor, constant: C.padding[3]),
		])
		info.constrain([
			info.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: C.padding[2]),
			info.topAnchor.constraint(equalTo: headerBackground.bottomAnchor, constant: C.padding[2]),
			info.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -C.padding[4]),
		])
		scrollView.addSubview(separator)
		separator.constrain([
			separator.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: C.padding[2]),
			separator.topAnchor.constraint(equalTo: info.bottomAnchor, constant: C.padding[2]),
			separator.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -C.padding[2]),
			separator.heightAnchor.constraint(equalToConstant: 1.0),
		])
		pinCell.constrain([
			pinCell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			pinCell.topAnchor.constraint(equalTo: separator.bottomAnchor),
			pinCell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
		])
		biometricsCell.constrain([
			biometricsCell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			biometricsCell.topAnchor.constraint(equalTo: pinCell.bottomAnchor),
			biometricsCell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
		])
		paperKeyCell.constrain([
			paperKeyCell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			paperKeyCell.topAnchor.constraint(equalTo: biometricsCell.bottomAnchor),
			paperKeyCell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			paperKeyCell.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -C.padding[2]),
		])

		if !LAContext.isBiometricsAvailable
		{
			biometricsCell.constrain([biometricsCell.heightAnchor.constraint(equalToConstant: 0.0)])
		}
	}

	private func setPinAndPhraseChecks()
	{
		pinCell.isCheckHighlighted = store.state.pinLength == 6
		paperKeyCell.isCheckHighlighted = !UserDefaults.walletRequiresBackup
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

extension SecurityCenterViewController: UIScrollViewDelegate
{
	func scrollViewDidScroll(_ scrollView: UIScrollView)
	{
		guard didViewAppear else { return } // We don't want to be doing an stretchy header stuff during interactive pop gestures
		let yOffset = scrollView.contentOffset.y + 20.0
		let newHeight = headerHeight - yOffset
		headerBackgroundHeight?.constant = newHeight

		if newHeight < fadeStart
		{
			let range = fadeStart - fadeEnd
			let alpha = (newHeight - fadeEnd) / range
			shield.alpha = max(alpha, 0.0)
		}
		else
		{
			shield.alpha = 1.0
		}
	}
}
