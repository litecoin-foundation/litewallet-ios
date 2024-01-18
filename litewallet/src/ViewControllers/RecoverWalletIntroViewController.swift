import UIKit

class RecoverWalletIntroViewController: UIViewController {
	// MARK: - Public

	init(didTapNext: @escaping () -> Void) {
		self.didTapNext = didTapNext
		super.init(nibName: nil, bundle: nil)
	}

	// MARK: - Private

	private let didTapNext: () -> Void
	private let header = RadialGradientView(backgroundColor: .purple)
	private let nextButton = ShadowButton(title: S.RecoverWallet.next.localize(), type: .primary)
	private let label = UILabel(font: .customBody(size: 16.0))
	private let illustration = UIImageView(image: #imageLiteral(resourceName: "RecoverWalletIllustration"))

	override func viewDidLoad() {
		addSubviews()
		addConstraints()
		setData()
	}

	private func addSubviews() {
		view.addSubview(header)
		header.addSubview(illustration)
		view.addSubview(nextButton)
		view.addSubview(label)
	}

	private func addConstraints() {
		header.constrainTopCorners(sidePadding: 0.0, topPadding: 0.0)
		header.constrain([header.heightAnchor.constraint(equalToConstant: C.Sizes.largeHeaderHeight)])
		illustration.constrain([
			illustration.centerXAnchor.constraint(equalTo: header.centerXAnchor),
			illustration.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: C.padding[2]),
		])
		label.constrain([
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.padding[2]),
			label.topAnchor.constraint(equalTo: header.bottomAnchor, constant: C.padding[2]),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.padding[2]),
		])
		nextButton.constrain([
			nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.padding[2]),
			nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -C.padding[3]),
			nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.padding[2]),
			nextButton.heightAnchor.constraint(equalToConstant: C.Sizes.buttonHeight),
		])
	}

	private func setData() {
		view.backgroundColor = .white
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.text = S.RecoverWallet.intro.localize()
		nextButton.tap = didTapNext
		title = S.RecoverWallet.header.localize()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
