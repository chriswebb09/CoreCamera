//
//  AlbumCollectionViewController.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/21/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol AlbumCollectionViewControllerDelegate: class {
    func navigateToCamera(tapped: Bool)
}

class AlbumCollectionViewController: UIViewController, Controller {
   
    var type: ControllerType = .album
    var images: [UIImage] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: AlbumCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let barButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(navigateBack))
        DispatchQueue.main.async {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(self.navigateBack))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dump(images)
        collectionView.reloadData()
        
    }
    
    @objc func navigateBack() {
        delegate?.navigateToCamera(tapped: true)
    }
}

extension AlbumCollectionViewController: UICollectionViewDelegate {
    
}

extension AlbumCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! ImageCell
        cell.photoView.image = images[indexPath.row]
        return cell
    }
}
