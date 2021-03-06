//
//  Coordinator.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/21/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol Coordinator: class { }

protocol CoordinatorDelegate: class { }

enum CoordinatorType {
    case start, app
}
