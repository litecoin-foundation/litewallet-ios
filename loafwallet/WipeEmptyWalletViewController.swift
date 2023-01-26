import UIKit

class WipeEmptyWalletViewController: UIViewController, Subscriber, Trackable {
	// MARK: - Public

	init(walletManager: WalletManager, store: Store, didTapYesDelete: @escaping () -> Void) {
		self.walletManager = walletManager
		self.store = store
		self.didTapYesDelete = didTapYesDelete
		super.init(nibName: nil, bundle: nil)
	}

	// MARK: - Private

	private let didTapYesDelete: () -> Void
	private let titleLabel = UILabel()
	private let warningDetailTextView = UITextView()
	private let warningAlertLabel = UILabel()
	private let border = UIView()
	private let reset = ShadowButton(title: S.WipeWallet.resetButton.localize(), type: .boldWarning)

	private var topSharePopoutConstraint: NSLayoutConstraint?
	private let walletManager: WalletManager

	private let store: Store
	private var resetTop: NSLayoutConstraint?
	private var resetBottom: NSLayoutConstraint?

	override func viewDidLoad() {
		addSubviews()
		addContent()
		addConstraints()
		setStyle()
		addActions()
	}

	private func addSubviews() {
		view.addSubview(titleLabel)
		view.addSubview(warningDetailTextView)
		view.addSubview(warningAlertLabel)
		view.addSubview(border)
		view.addSubview(reset)
	}

	private func addConstraints() {
		titleLabel.constrain([
			titleLabel.constraint(.width, constant: 210),
			titleLabel.constraint(.height, constant: 40),
			titleLabel.constraint(.top, toView: view, constant: C.padding[4]),
			titleLabel.constraint(.centerX, toView: view),
		])
		warningDetailTextView.constrain([
			warningDetailTextView.constraint(.width, constant: 300),
			warningDetailTextView.constraint(.height, constant: 300),
			warningDetailTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.0),
			warningDetailTextView.constraint(.centerX, toView: view),
		])
		warningAlertLabel.constrain([
			warningAlertLabel.constraint(.width, constant: 300),
			warningAlertLabel.constraint(.height, constant: 40),
			warningAlertLabel.constraint(.bottom, toView: warningDetailTextView, constant: -30.0),
			warningAlertLabel.constraint(.centerX, toView: view),
		])
		border.constrain([
			border.constraint(.width, toView: view),
			border.constraint(toBottom: warningDetailTextView, constant: 0.0),
			border.constraint(.centerX, toView: view),
			border.constraint(.height, constant: 1.0),
		])
		resetTop = reset.constraint(toBottom: border, constant: C.padding[3])
		resetBottom = reset.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: E.isIPhoneX ? -C.padding[5] : -C.padding[2])
		reset.constrain([
			resetTop,
			reset.constraint(.leading, toView: view, constant: C.padding[2]),
			reset.constraint(.trailing, toView: view, constant: -C.padding[2]),
			reset.constraint(.height, constant: C.Sizes.buttonHeight),
			resetBottom,
		])
	}

	private func addContent() {
		titleLabel.text = S.WipeWallet.warningTitle.localize()
		warningDetailTextView.text = S.WipeWallet.warningDescription.localize()
		warningAlertLabel.text = S.WipeWallet.warningAlert.localize()
	}

	private func setStyle() {
		view.backgroundColor = .white
		border.backgroundColor = .secondaryBorder

		titleLabel.font = UIFont.customBold(size: 24)
		titleLabel.textAlignment = .center
		warningDetailTextView.font = UIFont.customBody(size: 16)
		warningDetailTextView.textAlignment = .left
		warningDetailTextView.isUserInteractionEnabled = false
		warningAlertLabel.font = UIFont.customBold(size: 20)
		warningAlertLabel.textAlignment = .center
		warningAlertLabel.textColor = UIColor.pink
	}

	private func addActions() {
		reset.tap = { [weak self] in
			self?.didTapYesDelete()
		}
	}

	@objc private func resetTapped()
	{}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension WipeEmptyWalletViewController: ModalDisplayable {
	var faqArticleId: String? {
		return nil
	}

	var modalTitle: String {
		return S.WipeWallet.resetTitle.localize()
	}
}
