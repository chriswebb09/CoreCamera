//
//  MainCoordinator.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/21/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class MainCoordinator: AppCoordinator {
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    var childCoordinators: [ControllerCoordinator] = []
    var window: UIWindow
    var images: [UIImage] = []
    
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
 
    func updateImages(images: [UIImage]) {
        self.images.append(contentsOf: images)
    }
    
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
            let albumCoordinator = AlbumControllerCoordinator(window: window)
            addChildCoordinator(albumCoordinator)
            albumCoordinator.images.append(contentsOf: images)
            albumCoordinator.type = .album
            albumCoordinator.start()
        }
    }
}
