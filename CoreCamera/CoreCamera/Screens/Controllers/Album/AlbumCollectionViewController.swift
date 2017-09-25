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
    
    var imagesToSave: [UIImage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: AlbumCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let barButton = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(self.navigateBack))
        let doneButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.done))
        DispatchQueue.main.async {
            self.navigationItem.leftBarButtonItem = barButton
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Done", message: "Your photos have been saved.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func navigateBack() {
        delegate?.navigateToCamera(tapped: true)
    }
    
    @objc func done() {
        for image in imagesToSave {
            if images.contains(image) {
                let index = images.index(of: image)
                images.remove(at: index!)
                let context = CIContext()
                if let ciImage = image.ciImage, let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }
        collectionView.reloadData()
        imagesToSave.removeAll()
    }
}

extension AlbumCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        cell.configureCell(with: .selected)
        imagesToSave.append(image)
    }
}

extension AlbumCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! ImageCell
        cell.photoView.image = images[indexPath.row]
        cell.layoutSubviews()
        return cell
    }
}


