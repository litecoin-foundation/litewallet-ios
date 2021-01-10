//
//  GradientView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-22.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

protocol GradientDrawable {
    func drawGradient(_ rect: CGRect)
}

extension UIView {
    func drawGradient(_ rect: CGRect) {
        guard !E.isIPhone4 && !E.isIPhone5 else {
            addFallbackImageBackground()
            return
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.gradientStart.cgColor, UIColor.gradientEnd.cgColor] as CFArray
        let locations: [CGFloat] = [0.2, 0.9] // eyeball attempt! REDO
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: rect.width, y: 0.0), options: [])
    }

    private func addFallbackImageBackground() {
        let image = UIImageView(image: #imageLiteral(resourceName: "HeaderGradient"))
        image.contentMode = .scaleToFill
        addSubview(image)
        image.constrain(toSuperviewEdges: nil)
        sendSubview(toBack: image)
    }
}

class GradientView : UIView {
    override func draw(_ rect: CGRect) {
        drawGradient(rect)
    }
}

protocol SolidColorDrawable {
    func drawColor(color: UIColor, _ rect: CGRect)
}

extension UIView {
    func drawColor(color: UIColor = .liteWalletBlue, _ rect: CGRect) {
        let image = UIImageView(image: #imageLiteral(resourceName: "colorImageBlue"))
        image.contentMode = .scaleToFill
        addSubview(image)
        image.constrain(toSuperviewEdges: nil)
        sendSubview(toBack: image)
    }
}
