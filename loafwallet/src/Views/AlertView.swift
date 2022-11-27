//
//  AlertView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-22.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

enum AlertType {
    case pinSet(callback: () -> Void)
    case paperKeySet(callback: () -> Void)
    case sendSuccess
    case resolvedSuccess
    case addressesCopied
    case sweepSuccess(callback: () -> Void)
    
    //Failure(s)
    case failedResolution
    
    var header: String {
        switch self {
            case .pinSet:
                return S.SecurityAlerts.pinSet.localize()
            case .paperKeySet:
                return S.SecurityAlerts.paperKeySet.localize()
            case .sendSuccess:
                return S.SecurityAlerts.sendSuccess.localize()
            case .resolvedSuccess:
                return S.SecurityAlerts.resolvedSuccess.localize()
            case .addressesCopied:
                return S.SecurityAlerts.copiedAddressesHeader.localize()
            case .sweepSuccess:
                return S.Import.success.localize()
        
            // Failure(s)
            case .failedResolution:
                return S.SecurityAlerts.sendFailure.localize()
        }
    }
    
    var subheader: String {
        switch self {
            case .pinSet:
                return ""
            case .paperKeySet:
                return S.SecurityAlerts.paperKeySetSubheader.localize()
            case .sendSuccess:
                return S.SecurityAlerts.sendSuccessSubheader.localize()
            case .resolvedSuccess:
                return S.SecurityAlerts.resolvedSuccessSubheader.localize()
            case .addressesCopied:
                return S.SecurityAlerts.copiedAddressesSubheader.localize()
            case .sweepSuccess:
                return S.Import.successBody.localize()
                
            // Failure(s)
            case .failedResolution:
                return S.SecurityAlerts.resolvedSuccessSubheader.localize()
        }
    }
    
    var icon: UIView {
        return CheckView()
    }
}

extension AlertType : Equatable {}

func ==(lhs: AlertType, rhs: AlertType) -> Bool {
    switch (lhs, rhs) {
        case (.pinSet(_), .pinSet(_)):
            return true
        case (.paperKeySet(_), .paperKeySet(_)):
            return true
        case (.sendSuccess, .sendSuccess):
            return true
        case (.resolvedSuccess, .resolvedSuccess):
            return true
        case (.addressesCopied, .addressesCopied):
            return true
        case (.sweepSuccess(_), .sweepSuccess(_)):
            return true
            
        // Failure(s)
        case (.failedResolution, .failedResolution):
            return true
            
        default:
            return false
    }
}

class AlertView : UIView, SolidColorDrawable {

    private let type: AlertType
    private let header = UILabel()
    private let subheader = UILabel()
    private let separator = UIView()
    private let icon: UIView
    private let iconSize: CGFloat = 96.0
    private let separatorYOffset: CGFloat = 48.0
    
    init(type: AlertType) {
        self.type = type
        self.icon = type.icon
        super.init(frame: .zero)
        layer.cornerRadius = 6.0
        layer.masksToBounds = true
        setupSubviews()
    }
    
    func animate() {
        guard let animatableIcon = icon as? AnimatableIcon else { return }
        animatableIcon.animate()
    }
    
    private func setupSubviews() {
        addSubview(header)
        addSubview(subheader)
        addSubview(icon)
        addSubview(separator)
        
        setData()
        addConstraints()
    }
    
    private func setData() {
        header.text = type.header
        header.textAlignment = .center
        header.font = UIFont.barlowBold(size: 18.0)
        header.textColor = .white
        
        icon.backgroundColor = .clear
        separator.backgroundColor = .transparentWhite
        
        subheader.text = type.subheader
        subheader.textAlignment = .center
        subheader.font = UIFont.barlowSemiBold(size: 16.0)
        subheader.textColor = .white
    }
    
    private func addConstraints() {
        
        //NB - In this alert view, constraints shouldn't be pinned to the bottom
        //of the view because the bottom actually extends off the bottom of the screen a bit.
        //It extends so that it still covers up the underlying view when it bounces on screen.
        
        header.constrainTopCorners(sidePadding: C.padding[2], topPadding: C.padding[2])
        separator.constrain([
                                separator.constraint(.height, constant: 1.0),
                                separator.constraint(.width, toView: self, constant: 0.0),
                                separator.constraint(.top, toView: self, constant: separatorYOffset),
                                separator.constraint(.leading, toView: self, constant: nil) ])
        icon.constrain([
                        icon.constraint(.centerX, toView: self, constant: nil),
                        icon.constraint(.centerY, toView: self, constant: nil),
                        icon.constraint(.width, constant: iconSize),
                        icon.constraint(.height, constant: iconSize) ])
        subheader.constrain([
                                subheader.constraint(.leading, toView: self, constant: C.padding[2]),
                                subheader.constraint(.trailing, toView: self, constant: -C.padding[2]),
                                subheader.constraint(toBottom: icon, constant: C.padding[3]) ])
    }
    
    override func draw(_ rect: CGRect) {
        drawColor(color: .liteWalletBlue, rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

