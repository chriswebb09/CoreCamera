//
//  MainCoordinator.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/21/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MainCoordinator: AppCoordinator {
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    var childCoordinators: [ControllerCoordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        transitionCoordinator(type: .app)
    }
    
    func addChildCoordinator(_ childCoordinator: ControllerCoordinator) {
        childCoordinator.delegate = self
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}

extension MainCoordinator: ControllerCoordinatorDelegate {
    
    // Switch between application flows
    func transitionCoordinator(type: CoordinatorType) {
        
        // Remove previous application flow
        childCoordinators.removeAll()
        switch type {
        case .app:
            let cameraCoordinator = CameraControllerCoordinator(window: window)
            addChildCoordinator(cameraCoordinator)
            cameraCoordinator.type = .camera
            cameraCoordinator.start()
        case .start:
            print("start")
//            let startCoordinator = StartControllerCoordinator(window: window)
//            addChildCoordinator(startCoordinator)
//            startCoordinator.type = .start
//            startCoordinator.start()
        }
    }
}
