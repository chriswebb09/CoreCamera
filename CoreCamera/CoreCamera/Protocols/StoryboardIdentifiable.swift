//
//  StoryboardIdentifiable.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/21/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - Storyboard Identifiable
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

// MARK: - View Controller
extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
