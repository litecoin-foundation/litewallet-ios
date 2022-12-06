import UIKit

class PushNotificationsViewController: UIViewController {
	init(store: Store) {
		self.store = store
		super.init(nibName: nil, bundle: nil)
	}

	private let store: Store
	private let titleLabel = UILabel(font: .customBold(size: 26.0), color: .darkText)
	private let body = UILabel.wrapping(font: .customBody(size: 16.0), color: .darkText)
	private let label = UILabel(font: .customBold(size: 16.0), color: .darkText)
	private let toggle = GradientSwitch()
	private let separator = UIView(color: .secondaryShadow)

	override func viewDidLoad() {
		addSubviews()
		addConstraints()
		setData()
	}

	private func addSubviews() {
		view.addSubview(titleLabel)
		view.addSubview(body)
		view.addSubview(label)
		view.addSubview(toggle)
		view.addSubview(separator)
	}

	private func addConstraints() {
		titleLabel.constrain([
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.padding[2]),
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: C.padding[2]),
		])
		body.constrain([
			body.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			body.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.padding[1]),
			body.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.padding[2]),
		])
		label.constrain([
			label.leadingAnchor.constraint(equalTo: body.leadingAnchor),
			label.topAnchor.constraint(equalTo: body.bottomAnchor, constant: C.padding[3]),
		])
		toggle.constrain([
			toggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.padding[2]),
			toggle.centerYAnchor.constraint(equalTo: label.centerYAnchor),
		])
		separator.constrain([
			separator.leadingAnchor.constraint(equalTo: label.leadingAnchor),
			separator.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: C.padding[2]),
			separator.trailingAnchor.constraint(equalTo: toggle.trailingAnchor),
			separator.heightAnchor.constraint(equalToConstant: 1.0),
		])
	}

	private func setData() {
		view.backgroundColor = .whiteTint
		titleLabel.text = S.PushNotifications.title
		body.text = S.PushNotifications.body
		label.text = S.PushNotifications.label

		toggle.isOn = store.state.isPushNotificationsEnabled
		toggle.sendActions(for: .valueChanged)

		toggle.valueChanged = { [weak self] in
			guard let myself = self else { return }
			myself.store.perform(action: PushNotifications.setIsEnabled(myself.toggle.isOn))
			if myself.toggle.isOn {
				myself.store.trigger(name: .registerForPushNotificationToken)
			}
		}
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
