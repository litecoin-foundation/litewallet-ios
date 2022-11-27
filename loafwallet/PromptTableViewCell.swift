//
//  PromptTableViewCell.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.

import UIKit
import LocalAuthentication

class PromptTableViewCell : UITableViewCell {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    var type: PromptType? = nil
    var didClose: (() -> ())?
    var didTap: (() -> ())?
    
    @IBAction func didTapAction(_ sender: Any) {
        didTap?()
    }
    
    @IBAction func closeAction(_ sender: Any) {
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

    static var defaultOrder: [PromptType] = {
        return [.recommendRescan, .upgradePin, .paperKey, .noPasscode, .biometrics, .shareData]
    }()
    
    var title: String {
        switch self {
        case .biometrics: return LAContext.biometricType() == .face ? S.Prompts.FaceId.title.localize() : S.Prompts.TouchId.title.localize()
        case .paperKey: return S.Prompts.PaperKey.title.localize()
        case .upgradePin: return S.Prompts.SetPin.title.localize()
        case .recommendRescan: return S.Prompts.RecommendRescan.title.localize()
        case .noPasscode: return S.Prompts.NoPasscode.title.localize()
        case .shareData: return S.Prompts.ShareData.title.localize()
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
        }
    }

    //This is the trigger that happens when the prompt is tapped
    var trigger: TriggerName? {
        switch self {
        case .biometrics: return .promptBiometrics
        case .paperKey: return .promptPaperKey
        case .upgradePin: return .promptUpgradePin
        case .recommendRescan: return .recommendRescan
        case .noPasscode: return nil
        case .shareData: return .promptShareData
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
        }
    }
}
