//
//  BottomMenuViewable.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol BottomMenuViewable {
    
    var bottomMenu: BottomMenu { get set }
    
    func hidePopMenu(_ view: UIView)
    func showPopMenu(_ view: UIView)
    func moreButton(tapped: Bool)
}

extension BottomMenuViewable {
    
    func hidePopMenu(_ view: UIView) {
        bottomMenu.hideFrom(view)
    }
    
    func showPopMenu(_ view: UIView){
        bottomMenu.showOn(view)
    }
    
    func menuSetup() {
        let height = UIScreen.main.bounds.height * 0.5
        let width = UIScreen.main.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = UIScreen.main.bounds.width * 0.001
        let originY = UIScreen.main.bounds.height * 0.14
        let origin = CGPoint(x: originX, y: originY)
        
        
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
    }
}
