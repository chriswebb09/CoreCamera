//
//  ControlsBackgroundView.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/24/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ControlsBackgroundViewDelegate: class {
    func albumTapped(tapped: Bool)
}

class ControlsBackgroundView: UIView {
    weak var delegate: ControlsBackgroundViewDelegate?
    

    @IBAction func albumTapped(_ sender: Any) {
    }
}

