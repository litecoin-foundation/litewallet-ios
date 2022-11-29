//
//  LanguageSelectionViewController.swift
//  loafwallet
//
//  Created by Ivan Ferencak on 18.11.2022..
//  Copyright © 2022 Litecoin Foundation. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UITableViewController {

    let viewModel = LanguageSelectionViewModel()

    var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        tableView.register(SeparatorCell.self)
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .whiteTint
        tableView.separatorStyle = .none

        titleLabel = UILabel(font: .customBold(size: 17.0), color: .darkText)
        titleLabel.text = S.Settings.languages.localize()
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }

    func showConfirmationAlert(code: String) {
        if UserDefaults.selectedLanguage == code { return }
        let alert = UIAlertController(title: nil, message: S.Settings.changeLanguageMessage.localize().replacingOccurrences(of: "%l", with: "\(Locale.current.localizedString(forLanguageCode: code) ?? "") (\(code))"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: S.Fragments.confirm.localize().capitalized, style: .default, handler: {_ in
            self.viewModel.setLanguage(code: code)
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: S.Button.cancel.localize(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LanguageSelectionViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.localizations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SeparatorCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        cell.textLabel?.text = "\(Locale.current.localizedString(forLanguageCode: viewModel.localizations[indexPath.row]) ?? "") (\(viewModel.localizations[indexPath.row]))"
        cell.accessoryType = viewModel.localizations[indexPath.row] == UserDefaults.selectedLanguage ? .checkmark : .none
        cell.textLabel?.font = .customBody(size: 16.0)
        cell.textLabel?.textColor = UIColor(named: "labelTextColor")

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showConfirmationAlert(code: viewModel.localizations[indexPath.row])
    }
}
