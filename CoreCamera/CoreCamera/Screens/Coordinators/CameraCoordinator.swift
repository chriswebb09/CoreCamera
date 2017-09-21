//
//  CameraCoordinator.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/21/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//


import UIKit

class CameraControllerCoordinator: ControllerCoordinator {
    
    var window: UIWindow
    var rootController: RootController!
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            if let storyboard = try? UIStoryboard(.camera) {
                if let viewController: CameraViewController = try? storyboard.instantiateViewController() {
                    rootController = viewController
                    viewController.setup()
                }
            }
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        type = .camera
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
