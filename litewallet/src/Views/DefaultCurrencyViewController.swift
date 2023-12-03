import UIKit

class DefaultCurrencyViewController: UITableViewController, Subscriber {
	init(walletManager: WalletManager, store: Store) {
		self.walletManager = walletManager
		self.store = store
		rates = store.state.rates.filter { $0.code != C.btcCurrencyCode }
		super.init(style: .plain)
	}

	private let walletManager: WalletManager
	private let store: Store
	private let cellIdentifier = "CellIdentifier"
	private var rates: [Rate] = [] {
		didSet {
			tableView.reloadData()
			setExchangeRateLabel()
		}
	}

	private var defaultCurrencyCode: String? {
		didSet {
			// Grab index paths of new and old rows when the currency changes
			let paths: [IndexPath] = rates.enumerated().filter { $0.1.code == defaultCurrencyCode || $0.1.code == oldValue }.map { IndexPath(row: $0.0, section: 0) }
			tableView.beginUpdates()
			tableView.reloadRows(at: paths, with: .automatic)
			tableView.endUpdates()

			setExchangeRateLabel()
		}
	}

	private let bitcoinLabel = UILabel(font: .customBold(size: 14.0), color: .grayTextTint)
	private let bitcoinSwitch = UISegmentedControl(items: ["photons (\(S.Symbols.photons))", "lites (\(S.Symbols.lites))", "LTC (\(S.Symbols.ltc))"])
	private let rateLabel = UILabel(font: .customBody(size: 16.0), color: .darkText)
	private var header: UIView?

	deinit {
		store.unsubscribe(self)
	}

	override func viewDidLoad() {
		tableView.register(SeparatorCell.self, forCellReuseIdentifier: cellIdentifier)
		store.subscribe(self, selector: { $0.defaultCurrencyCode != $1.defaultCurrencyCode }, callback: {
			self.defaultCurrencyCode = $0.defaultCurrencyCode

		})
		store.subscribe(self, selector: { $0.maxDigits != $1.maxDigits }, callback: { _ in
			self.setExchangeRateLabel()
		})

		tableView.sectionHeaderHeight = UITableView.automaticDimension
		tableView.estimatedSectionHeaderHeight = 140.0
		tableView.backgroundColor = .whiteTint
		tableView.separatorStyle = .none

		let titleLabel = UILabel(font: .customBold(size: 17.0), color: .darkText)
		titleLabel.text = S.Settings.currency.localize()
		titleLabel.sizeToFit()
		navigationItem.titleView = titleLabel

		let faqButton = UIButton.buildFaqButton(store: store, articleId: ArticleIds.nothing)
		faqButton.tintColor = .darkText
		navigationItem.rightBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: faqButton)]
	}

	private func setExchangeRateLabel() {
		if let currentRate = rates.filter({ $0.code == defaultCurrencyCode }).first {
			let amount = Amount(amount: C.satoshis, rate: currentRate, maxDigits: store.state.maxDigits)
			let bitsAmount = Amount(amount: C.satoshis, rate: currentRate, maxDigits: store.state.maxDigits)
			rateLabel.textColor = .darkText
			rateLabel.text = "\(bitsAmount.bits) = \(amount.string(forLocal: currentRate.locale))"
		}
	}

	override func numberOfSections(in _: UITableView) -> Int {
		return 1
	}

	override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		return rates.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		let rate = rates[indexPath.row]
		cell.textLabel?.text = "\(rate.code) (\(rate.currencySymbol))"

		if rate.code == defaultCurrencyCode {
			let check = UIImageView(image: #imageLiteral(resourceName: "CircleCheck").withRenderingMode(.alwaysTemplate))
			check.tintColor = C.defaultTintColor
			cell.accessoryView = check
		} else {
			cell.accessoryView = nil
		}

		return cell
	}

	override func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
		if let header = self.header { return header }

		let header = UIView(color: .whiteTint)
		let rateLabelTitle = UILabel(font: .customBold(size: 14.0), color: .grayTextTint)

		header.addSubview(rateLabelTitle)
		header.addSubview(rateLabel)
		header.addSubview(bitcoinLabel)
		header.addSubview(bitcoinSwitch)

		rateLabelTitle.constrain([
			rateLabelTitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: C.padding[2]),
			rateLabelTitle.topAnchor.constraint(equalTo: header.topAnchor, constant: C.padding[1]),
		])
		rateLabel.constrain([
			rateLabel.leadingAnchor.constraint(equalTo: rateLabelTitle.leadingAnchor),
			rateLabel.topAnchor.constraint(equalTo: rateLabelTitle.bottomAnchor),
		])

		bitcoinLabel.constrain([
			bitcoinLabel.leadingAnchor.constraint(equalTo: rateLabelTitle.leadingAnchor),
			bitcoinLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: C.padding[2]),
		])
		bitcoinSwitch.constrain([
			bitcoinSwitch.leadingAnchor.constraint(equalTo: bitcoinLabel.leadingAnchor),
			bitcoinSwitch.topAnchor.constraint(equalTo: bitcoinLabel.bottomAnchor, constant: C.padding[1]),
			bitcoinSwitch.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -C.padding[2]),
			bitcoinSwitch.widthAnchor.constraint(equalTo: header.widthAnchor, constant: -C.padding[4]),
		])

		let settingSegment = store.state.maxDigits
		switch settingSegment {
		case 2: bitcoinSwitch.selectedSegmentIndex = 0
		case 5: bitcoinSwitch.selectedSegmentIndex = 1
		case 8: bitcoinSwitch.selectedSegmentIndex = 2
		default: bitcoinSwitch.selectedSegmentIndex = 2
		}

		bitcoinSwitch.valueChanged = strongify(self) { myself in
			let newIndex = myself.bitcoinSwitch.selectedSegmentIndex

			switch newIndex {
			case 0: // photons
				myself.store.perform(action: MaxDigits.set(2))
			case 1: // lites
				myself.store.perform(action: MaxDigits.set(5))
			case 2: // LTC
				myself.store.perform(action: MaxDigits.set(8))
			default: // LTC
				myself.store.perform(action: MaxDigits.set(8))
			}
		}

		bitcoinLabel.text = S.DefaultCurrency.bitcoinLabel.localize()
		rateLabelTitle.text = S.DefaultCurrency.rateLabel.localize()

		self.header = header
		return header
	}

	override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		let rate = rates[indexPath.row]
		store.perform(action: DefaultCurrency.setDefault(rate.code))
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
