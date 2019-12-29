//
//  LanguagesViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/29/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit

//extension BartyCrouch: CustomStringConvertible {
//    var description: String {
//        return "\(rawValue)"
//    }
//}
  
class LanguagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    let localizationStrings: [String] = {
        
        var codeArray = [String]()
        Bundle.main.localizations.forEach { (code) in
            let locale = Locale.init(identifier: code)
            guard let langStr = locale.localizedString(forIdentifier: code)?.uppercased() else {return}
            codeArray.append(langStr)
         }
        
         return codeArray
    }()
    
    var currentLanguageCell: LanguagesTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguageButton.setTitle(S.Settings.changelanguage, for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localizationStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languagesCell", for: indexPath) as? LanguagesTableViewCell
        let localizationString = localizationStrings[indexPath.row]
        cell?.fullNameLabel.text = localizationString
        cell?.selectionImageView.image = cell?.selectionImageView.image?.withRenderingMode(.alwaysTemplate)
        cell?.selectionImageView.tintColor = .liteWalletBlue
        let code = Bundle.main.localizations[indexPath.row]
        cell?.languageCode = code
        
        if code == Locale.current.languageCode {
            cell?.selectionImageView.alpha = 1.0
            self.currentLanguageCell = cell
        } else {
            cell?.selectionImageView.alpha = 0.0
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! LanguagesTableViewCell
        selectedCell.selectionImageView.alpha = 1.0
        self.currentLanguageCell?.selectionImageView.alpha = 0.0
        self.currentLanguageCell = selectedCell 
    }
    
    @IBAction func didTapChangeLanguageAction(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        
//        UserDefaults.standard.set([currentLanguageCell?.languageCode], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
    }
    
}

class LanguagesTableViewCell: UITableViewCell {
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var languageCode: String  = ""
    
     override func awakeFromNib() {
         super.awakeFromNib()
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
    
}
