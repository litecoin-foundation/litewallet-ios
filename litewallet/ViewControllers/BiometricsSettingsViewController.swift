import LocalAuthentication
import UIKit

class BiometricsSettingsViewController: UIViewController, Subscriber {
	var presentSpendingLimit: (() -> Void)?
	var didDismiss: (() -> Void)?

	init(walletManager: WalletManager, store: Store) {
		self.walletManager = walletManager
		self.store = store
		super.init(nibName: nil, bundle: nil)
	}

	private let header = RadialGradientView(backgroundColor: .darkPurple)
	private let illustration = LAContext.biometricType() == .face ? UIImageView(image: #imageLiteral(resourceName: "FaceId-Large")) : UIImageView(image: #imageLiteral(resourceName: "TouchId-Large"))
	private var label = UILabel.wrapping(font: .customBody(size: 16.0), color: .darkText)
	private var switchLabel = UILabel(font: .customBold(size: 14.0), color: .darkText)
	private var spendingLimitLabel = UILabel(font: .customBold(size: 14.0), color: .darkText)
	private var spendingButton = ShadowButton(title: "-", type: .secondary)
	private var dismissButton = UIButton()

	private let toggle = GradientSwitch()
	private let separator = UIView(color: .secondaryShadow)
	private let walletManager: WalletManager
	private let store: Store
	private var rate: Rate?
	fileprivate var didTapSpendingLimit = false

	deinit {
		store.unsubscribe(self)
	}

	override func viewDidLoad() {
		store.subscribe(self, selector: { $0.currentRate != $1.currentRate }, callback: {
			self.rate = $0.currentRate
		})

		addSubviews()
		addConstraints()
		setData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		didTapSpendingLimit = false
		spendingButton.title = spendingButtonText
	}

	private func addSubviews() {
		view.addSubview(header)
		header.addSubview(illustration)
		view.addSubview(label)
		view.addSubview(switchLabel)
		view.addSubview(toggle)
		view.addSubview(spendingLimitLabel)
		view.addSubview(spendingButton)
		view.addSubview(separator)
		view.addSubview(dismissButton)
	}

	private func addConstraints() {
		header.constrainTopCorners(sidePadding: 0.0, topPadding: 0.0)
		header.constrain([header.heightAnchor.constraint(equalToConstant: C.Sizes.largeHeaderHeight)])
		illustration.constrain([
			illustration.centerXAnchor.constraint(equalTo: header.centerXAnchor),
			illustration.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: E.isIPhoneX ? C.padding[4] : C.padding[2]),
		])
		dismissButton.constrain([
			dismissButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: C.padding[2]),
			dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: C.padding[2]),
		])
		label.constrain([
			label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: C.padding[2]),
			label.topAnchor.constraint(equalTo: header.bottomAnchor, constant: C.padding[2]),
			label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -C.padding[2]),
		])
		switchLabel.constrain([
			switchLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
			switchLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: C.padding[2]),
		])
		toggle.constrain([
			toggle.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
			toggle.trailingAnchor.constraint(equalTo: label.trailingAnchor),
		])
		spendingLimitLabel.constrain([
			spendingLimitLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
			spendingLimitLabel.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: C.padding[4]),
		])
		spendingButton.constrain([
			spendingButton.centerYAnchor.constraint(equalTo: spendingLimitLabel.centerYAnchor),
			spendingButton.trailingAnchor.constraint(equalTo: label.trailingAnchor),
		])
		separator.constrain([
			separator.leadingAnchor.constraint(equalTo: switchLabel.leadingAnchor),
			separator.topAnchor.constraint(equalTo: spendingButton.bottomAnchor, constant: C.padding[1]),
			separator.trailingAnchor.constraint(equalTo: spendingButton.trailingAnchor),
			separator.heightAnchor.constraint(equalToConstant: 1.0),
		])
	}

	private func setData() {
		spendingButton.addTarget(self, action: #selector(didTapSpendingButton), for: .touchUpInside)
		if #available(iOS 11.0, *), let backGroundColor = UIColor(named: "lfBackgroundColor"),
		   let textColor = UIColor(named: "labelTextColor")
		{
			label.textColor = textColor
			switchLabel.textColor = textColor
			spendingLimitLabel.textColor = textColor
			view.backgroundColor = backGroundColor
		} else {
			label.textColor = .darkText
			switchLabel.textColor = .darkText
			view.backgroundColor = .white
		}

		title = LAContext.biometricType() == .face ? S.FaceIDSettings.title.localize() : S.TouchIdSettings.title.localize()
		label.text = LAContext.biometricType() == .face ? S.FaceIDSettings.label.localize() : S.TouchIdSettings.label.localize()
		switchLabel.text = LAContext.biometricType() == .face ? S.FaceIDSettings.switchLabel.localize() : S.TouchIdSettings.switchLabel.localize()
		spendingLimitLabel.text = S.SpendingLimit.titleLabel.localize()
		spendingButton.title = spendingButtonText
		let hasSetToggleInitialValue = false
		store.subscribe(self, selector: { $0.isBiometricsEnabled != $1.isBiometricsEnabled }, callback: {
			self.toggle.isOn = $0.isBiometricsEnabled
			if !hasSetToggleInitialValue {
				self.toggle.sendActions(for: .valueChanged) // This event is needed because the gradient background gets set on valueChanged events
			}
		})
		toggle.valueChanged = { [weak self] in
			guard let myself = self else { return }

			if LAContext.canUseBiometrics {
				myself.store.perform(action: Biometrics.setIsEnabled(myself.toggle.isOn))
				myself.spendingButton.title = myself.spendingButtonText
			} else {
				myself.presentCantUseBiometricsAlert()
				myself.toggle.isOn = false
			}
		}

		dismissButton.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
		dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
	}

	private var spendingButtonText: String {
		guard let rate = rate else { return "" }
		let amount = Amount(amount: walletManager.spendingLimit, rate: rate, maxDigits: store.state.maxDigits)
		let string = "\(String(format: S.TouchIdSettings.limitValue.localize(), amount.bits, amount.localCurrency))"
		return string
	}

	fileprivate func presentCantUseBiometricsAlert() {
		let unavailableAlertTitle = LAContext.biometricType() == .face ? S.FaceIDSettings.unavailableAlertTitle.localize() : S.TouchIdSettings.unavailableAlertTitle.localize()
		let unavailableAlertMessage = LAContext.biometricType() == .face ? S.FaceIDSettings.unavailableAlertMessage.localize() : S.TouchIdSettings.unavailableAlertMessage.localize()
		let alert = UIAlertController(title: unavailableAlertTitle, message: unavailableAlertMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: S.Button.ok.localize(), style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	@objc func didTapSpendingButton() {
		if LAContext.canUseBiometrics {
			didTapSpendingLimit = true
			presentSpendingLimit?()
		} else {
			presentCantUseBiometricsAlert()
		}
	}

	@objc func didTapDismissButton() {
		didDismiss?()
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
