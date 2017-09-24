//
//  AlbumControllerCoordinator.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/24/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//
import UIKit

final class AlbumControllerCoordinator: ControllerCoordinator {
    
    internal var window: UIWindow
    internal var rootController: RootController!
    
    var images: [UIImage] = []
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            if let storyboard = try? UIStoryboard(.album) {
                if let viewController: AlbumCollectionViewController = try? storyboard.instantiateViewController() {
                    viewController.delegate = self
                    viewController.images = images
                    rootController = viewController
                }
            }
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        type = .album
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AlbumControllerCoordinator: AlbumCollectionViewControllerDelegate {
    
    func navigateToCamera(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app)
    }
}
