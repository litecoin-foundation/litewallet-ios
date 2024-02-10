import SafariServices
import SwiftUI
import UIKit
import WebKit

class BuyTableViewController: UITableViewController, SFSafariViewControllerDelegate {
	@IBOutlet var bitrefillLogoImageView: UIImageView!
	@IBOutlet var bitrefillHeaderLabel: UILabel!
	@IBOutlet var bitrefillDetailsLabel: UILabel!
	@IBOutlet var bitrefillCellContainerView: UIView!
	@IBAction func didTapBitrefill(_: UIButton) {
		guard let url = URL(string: "https://www.bitrefill.com/?ref=bAshL935")
		else {
			return
		}

		let sfSafariVC = SFSafariViewController(url: url)
		sfSafariVC.delegate = self
		present(sfSafariVC, animated: true)
	}

	// MARK: Moonpay UI

	@IBOutlet var moonpayLogoImageView: UIImageView!
	@IBOutlet var moonpayHeaderLabel: UILabel!
	@IBOutlet var moonpayDetailsLabel: UILabel!
	@IBOutlet var moonpayCellContainerView: UIView!
	@IBOutlet var moonpaySegmentedControl: UISegmentedControl!

	@IBAction func didTapMoonpay(_: Any) {
		let timestamp = Int(Date().timeIntervalSince1970)

		let urlString = APIServer.baseUrl + "moonpay/buy" + "?address=\(currentWalletAddress)&idate=\(timestamp)&uid=\(uuidString)&code=\(currencyCode)"

		guard let url = URL(string: urlString) else { return }

		let sfSafariVC = SFSafariViewController(url: url)
		sfSafariVC.delegate = self
		present(sfSafariVC, animated: true)
	}

	// MARK: Simplex UI

	@IBOutlet var simplexLogoImageView: UIImageView!
	@IBOutlet var simplexHeaderLabel: UILabel!
	@IBOutlet var simplexDetailsLabel: UILabel!
	@IBOutlet var simplexCellContainerView: UIView!
	@IBOutlet var simplexCurrencySegmentedControl: UISegmentedControl!

	private var currencyCode: String = "USD"
	private let uuidString: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
	private let currentWalletAddress: String = WalletManager.sharedInstance.wallet?.receiveAddress ?? ""

	@IBAction func didTapSimplex(_: Any) {
		if let vcWKVC = UIStoryboard(name: "Buy", bundle: nil).instantiateViewController(withIdentifier: "BuyWKWebViewController") as? BuyWKWebViewController
		{
			vcWKVC.currencyCode = currencyCode
			vcWKVC.currentWalletAddress = currentWalletAddress
			vcWKVC.uuidString = uuidString
			vcWKVC.timestamp = Int(Date().timeIntervalSince1970)

			addChildViewController(vcWKVC)
			view.addSubview(vcWKVC.view)
			vcWKVC.didMove(toParentViewController: self)

			vcWKVC.didDismissChildView = {
				for vc in self.childViewControllers {
					DispatchQueue.main.async {
						vc.willMove(toParentViewController: nil)
						vc.view.removeFromSuperview()
						vc.removeFromParentViewController()
					}
				}
			}
		} else {
			NSLog("ERROR: Storyboard not initialized")
		}
	}

	var store: Store?
	var walletManager: WalletManager?

	override func viewDidLoad() {
		super.viewDidLoad()

		let thinHeaderView = UIView()
		thinHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.0)
		thinHeaderView.backgroundColor = .white
		tableView.tableHeaderView = thinHeaderView
		tableView.tableFooterView = UIView()

		moonpaySegmentedControl.addTarget(self, action: #selector(didChangeCurrencyMoonpay), for: .valueChanged)
		moonpaySegmentedControl.selectedSegmentIndex = PartnerFiatOptions.usd.index
		moonpaySegmentedControl.selectedSegmentTintColor = .white
		moonpaySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		moonpaySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.liteWalletBlue], for: .selected)

		simplexCurrencySegmentedControl.addTarget(self, action: #selector(didChangeCurrencySimplex), for: .valueChanged)
		simplexCurrencySegmentedControl.selectedSegmentIndex = PartnerFiatOptions.usd.index
		simplexCurrencySegmentedControl.selectedSegmentTintColor = .white
		simplexCurrencySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		simplexCurrencySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.liteWalletBlue], for: .selected)

		setupWkVCData()

		LWAnalytics.logEventWithParameters(itemName: ._20191105_DTBT)
	}

	private func setupWkVCData() {
		let bitrefillData = Partner.partnerDataArray()[0]
		bitrefillLogoImageView.image = bitrefillData.logo
		bitrefillHeaderLabel.text = bitrefillData.headerTitle
		bitrefillDetailsLabel.text = bitrefillData.details
		bitrefillCellContainerView.layer.cornerRadius = 6.0
		bitrefillCellContainerView.layer.borderColor = UIColor.white.cgColor
		bitrefillCellContainerView.layer.borderWidth = 1.0
		bitrefillCellContainerView.clipsToBounds = true

		let moonpayData = Partner.partnerDataArray()[1]
		moonpayLogoImageView.image = moonpayData.logo
		moonpayHeaderLabel.text = moonpayData.headerTitle
		moonpayDetailsLabel.text = moonpayData.details
		moonpayCellContainerView.layer.cornerRadius = 6.0
		moonpayCellContainerView.layer.borderColor = UIColor.white.cgColor
		moonpayCellContainerView.layer.borderWidth = 1.0
		moonpayCellContainerView.clipsToBounds = true

		let simplexData = Partner.partnerDataArray()[2]
		simplexLogoImageView.image = simplexData.logo
		simplexHeaderLabel.text = simplexData.headerTitle
		simplexDetailsLabel.text = simplexData.details
		simplexCellContainerView.layer.cornerRadius = 6.0
		simplexCellContainerView.layer.borderColor = UIColor.white.cgColor
		simplexCellContainerView.layer.borderWidth = 1.0
		simplexCellContainerView.clipsToBounds = true
	}

	@objc private func didChangeCurrencyMoonpay() {
		if let code = PartnerFiatOptions(rawValue: moonpaySegmentedControl.selectedSegmentIndex)?.description
		{
			currencyCode = code
		} else {
			print("Error: Code not found: \(moonpaySegmentedControl.selectedSegmentIndex)")
		}
	}

	@objc private func didChangeCurrencySimplex() {
		if let code = PartnerFiatOptions(rawValue: simplexCurrencySegmentedControl.selectedSegmentIndex)?.description
		{
			currencyCode = code
		} else {
			print("Error: Code not found: \(simplexCurrencySegmentedControl.selectedSegmentIndex)")
		}
	}
}
