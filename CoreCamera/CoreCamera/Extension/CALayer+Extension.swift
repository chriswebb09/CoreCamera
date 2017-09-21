//
//  CALayer+Extension.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension CALayer {
    
    static func createButton() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red:0.93, green:0.27, blue:0.27, alpha:1.0).cgColor
        return layer
    }
    
    func setupButton() {
        opacity = 1
        cornerRadius = frame.width / 2
        position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        borderWidth = 4.0
        borderColor = UIColor.white.cgColor
        shadowOpacity = 0.2
        shadowOffset = CGSize(width: 0, height: 3)
        shadowRadius = 3.0
    }
    
    func setCellShadow(contentView: UIView) {
        let shadowOffsetWidth: CGFloat = contentView.bounds.height * CALayerConstants.shadowWidthMultiplier
        let shadowOffsetHeight: CGFloat = contentView.bounds.width * CALayerConstants.shadowHeightMultiplier
        shadowColor = UIColor.gray.cgColor
        shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        shadowRadius =  1
        shadowOpacity = 0.5
    }
}

struct CALayerConstants {
    static let shadowWidthMultiplier: CGFloat = 0.0000001
    static let shadowHeightMultiplier: CGFloat = 0.000001
}
