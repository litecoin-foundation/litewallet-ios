import LocalAuthentication
import UIKit

class PromptTableViewCell: UITableViewCell {
	@IBOutlet var closeButton: UIButton!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var bodyLabel: UILabel!
	@IBOutlet var tapButton: UIButton!

	var type: PromptType?
	var didClose: (() -> Void)?
	var didTap: (() -> Void)?

	@IBAction func didTapAction(_: Any) {
		didTap?()
	}

	@IBAction func closeAction(_: Any) {
		didClose?()
	}
}

enum PromptType {
	case biometrics
	case paperKey
	case upgradePin
	case recommendRescan
	case noPasscode
	case shareData
	case deprecationWarning

	static var defaultOrder: [PromptType] = [.deprecationWarning, .recommendRescan, .upgradePin, .paperKey, .noPasscode, .biometrics, .shareData]

	var title: String {
		switch self {
		case .biometrics: return LAContext.biometricType() == .face ? S.Prompts.FaceId.title.localize() : S.Prompts.TouchId.title.localize()
		case .paperKey: return S.Prompts.PaperKey.title.localize()
		case .upgradePin: return S.Prompts.SetPin.title.localize()
		case .recommendRescan: return S.Prompts.RecommendRescan.title.localize()
		case .noPasscode: return S.Prompts.NoPasscode.title.localize()
		case .shareData: return S.Prompts.ShareData.title.localize()
		case .deprecationWarning: return "⚠️ App Deprecation Notice"
		}
	}

	var name: String {
		switch self {
		case .biometrics: return "biometricsPrompt"
		case .paperKey: return "paperKeyPrompt"
		case .upgradePin: return "upgradePinPrompt"
		case .recommendRescan: return "recommendRescanPrompt"
		case .noPasscode: return "noPasscodePrompt"
		case .shareData: return "shareDataPrompt"
		case .deprecationWarning: return "deprecationWarningPrompt"
		}
	}

	var body: String {
		switch self {
		case .biometrics: return LAContext.biometricType() == .face ? S.Prompts.FaceId.body.localize() : S.Prompts.TouchId.body.localize()
		case .paperKey: return S.Prompts.PaperKey.body.localize()
		case .upgradePin: return S.Prompts.SetPin.body.localize()
		case .recommendRescan: return S.Prompts.RecommendRescan.body.localize()
		case .noPasscode: return S.Prompts.NoPasscode.body.localize()
		case .shareData: return S.Prompts.ShareData.body.localize()
		case .deprecationWarning: return "Litewallet is no longer being maintained. Please upgrade to Nexus Wallet for Litecoin."
		}
	}

	// This is the trigger that happens when the prompt is tapped
	var trigger: TriggerName? {
		switch self {
		case .biometrics: return .promptBiometrics
		case .paperKey: return .promptPaperKey
		case .upgradePin: return .promptUpgradePin
		case .recommendRescan: return .recommendRescan
		case .noPasscode: return nil
		case .shareData: return .promptShareData
		case .deprecationWarning: return nil // We'll handle this with custom buttons
		}
	}

	func shouldPrompt(walletManager: WalletManager, state: ReduxState) -> Bool {
		switch self {
		case .biometrics:
			return !UserDefaults.hasPromptedBiometrics && LAContext.canUseBiometrics && !UserDefaults.isBiometricsEnabled
		case .paperKey:
			return UserDefaults.walletRequiresBackup
		case .upgradePin:
			return walletManager.pinLength != 6
		case .recommendRescan:
			return state.recommendRescan
		case .noPasscode:
			return !LAContext.isPasscodeEnabled
		case .shareData:
			return !UserDefaults.hasAquiredShareDataPermission && !UserDefaults.hasPromptedShareData
		case .deprecationWarning:
			return true // Always show the deprecation warning
		}
	}
}

// MARK: - Deprecation Warning Cell

class DeprecationWarningCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemYellow.cgColor
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray
        button.backgroundColor = .clear
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .barlowSemiBold(size: 16)
        label.textColor = .systemYellow
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .barlowRegular(size: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let getNexusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Nexus Wallet", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemYellow
        button.titleLabel?.font = .barlowSemiBold(size: 14)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn More", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .barlowRegular(size: 14)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Callbacks
    
    var didClose: (() -> Void)?
    var didTapGetNexus: (() -> Void)?
    var didTapLearnMore: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(getNexusButton)
        buttonStackView.addArrangedSubview(learnMoreButton)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set content priorities to ensure proper text wrapping
        bodyLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        bodyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Close button constraints
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            // Body label constraints
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Button stack view constraints
            buttonStackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        getNexusButton.addTarget(self, action: #selector(getNexusButtonTapped), for: .touchUpInside)
        learnMoreButton.addTarget(self, action: #selector(learnMoreButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    
    func configure(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        didClose?()
    }
    
    @objc private func getNexusButtonTapped() {
        didTapGetNexus?()
    }
    
    @objc private func learnMoreButtonTapped() {
        didTapLearnMore?()
    }
}
