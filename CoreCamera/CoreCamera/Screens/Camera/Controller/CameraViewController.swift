//
//  ViewController.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import GLKit

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak private var filterButton: UIButton!
    @IBOutlet weak private var videoView: UIImageView!
    
    var capturedImage: UIImage!
    var capturedImages: [UIImage] = []
    
    internal var bottomMenu = BottomMenu()
    
    @IBOutlet weak private var cameraView: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    private lazy var buttonLayer: CALayer = {
        let layer = CALayer.createButton()
        layer.opacity = 0
        self.cameraView.layer.addSublayer(layer)
        return layer
    }()
    
    var camera: Camera!
    
    var photoButtonEnabled: Bool = true
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let invertColorFilter = CIFilter(name: "CIColorInvert")
    private let comicFilter = CIFilter(name: "CIComicEffect")
    private let glassDistortionFilter = CIFilter(name: "CISepiaTone")
    private let twirlDistortionFilter = CIFilter(name: "CITwirlDistortion")
    
    private let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    private let pulseAnimationSize: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
    
    private var filtering: Bool! = false {
        didSet {
            if let camera = camera {
                camera.filtering = filtering
            }
            if filtering {
                let image = #imageLiteral(resourceName: "lightning-full-small").withRenderingMode(.alwaysTemplate)
                filterButton.setImage(image, for: .normal)
            } else if !filtering {
                let image = #imageLiteral(resourceName: "lightning-small").withRenderingMode(.alwaysTemplate)
                filterButton.setImage(image, for: .normal)
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        filterButton.tintColor = .white
        camera = Camera()
        camera.delegate = self
        setupButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.bounds = cameraView.frame
    }
    
    // MARK: - Rotation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    private func animatePulse() {
        pulseAnimation.duration = 0.6
        pulseAnimation.fromValue = 0.4
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimationSize.duration = 1
        pulseAnimationSize.toValue = NSNumber(value: 0.5)
        pulseAnimationSize.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.buttonLayer.removeAnimation(forKey: "animateOpacity")
            self?.buttonLayer.removeAnimation(forKey: "animateSize")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if photoButtonEnabled {
            addAnimations()
            let touch: UITouch = touches.first! as UITouch
            let touchLocation = touch.location(in: self.view)
            if buttonLayer.frame.contains(touchLocation) {
                takePhoto(tapped: true)
            }
        }
    }
    
    private func addAnimations() {
        buttonLayer.add(pulseAnimation, forKey: "animateOpacity")
        buttonLayer.add(pulseAnimation, forKey: "animateSize")
        animatePulse()
    }
    
    private func removeAnimations() {
        buttonLayer.removeAnimation(forKey: "animateOpacity")
        buttonLayer.removeAnimation(forKey: "animateSize")
    }
    
    private func setupButton() {
        let size = CGSize(width: view.frame.width / 4.4, height: view.frame.width / 4.4)
        let origin = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        let rect = CGRect(origin: origin, size: size)
        displayRect(rect: rect)
    }
    
    @IBAction func changeFilterTapped(_ sender: Any) {
        moreButton(tapped: true)
    }
    
    func takePhoto(tapped: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            print(strongSelf.capturedImage)
            strongSelf.capturedImages.append(strongSelf.capturedImage)
            strongSelf.collectionView.reloadData()
        }
    }
    
    private func displayRect(rect: CGRect) {
        buttonLayer.frame = rect
        buttonLayer.setupButton()
    }
}

extension CameraViewController: BottomMenuViewable, MenuDelegate  {
    
    func moreButton(tapped: Bool) {
        menuSetup()
        bottomMenu.menu.delegate = self
        showPopMenu(cameraView)
        photoButtonEnabled = false
    }
    
    func optionOne(tapped: Bool) {
        print("option one")
        filterButton.tintColor = .white
        camera.currentFilter = comicFilter
        hidePopMenu(cameraView)
        photoButtonEnabled = true
        filtering = true
    }
    
    func optionTwo(tapped: Bool) {
        print("option two")
        filterButton.tintColor = .white
        camera.currentFilter = CIFilter(name: "CICrystallize")!
        camera.currentFilter.setValue(25, forKey: kCIInputRadiusKey)
        hidePopMenu(cameraView)
        photoButtonEnabled = true
        filtering = true
    }
    
    func optionThree(tapped: Bool) {
        print("option three")
        filterButton.tintColor = .black
        camera.currentFilter = invertColorFilter
        hidePopMenu(cameraView)
        photoButtonEnabled = true
        filtering = true
    }
    
    func optionFour(tapped: Bool) {
        print("option four")
        filterButton.tintColor = .white
        //let filter =
        let filter = CIFilter(name: "CIVortexDistortion", withInputParameters:[kCIInputAngleKey: 200])
          //  vortexCI(angle: 200)
            //sepia() • blur(radius: 4.0) •
        camera.currentFilter = filter
        hidePopMenu(cameraView)
        photoButtonEnabled = true
        filtering = true
    }
    
    func cancel(tapped: Bool) {
        hidePopMenu(cameraView)
        photoButtonEnabled = true
        filterButton.tintColor = .white
    }
}

extension CameraViewController: CameraDelegate {
    func update(image: UIImage) {
        DispatchQueue.main.async {
            self.videoView.image = image
            self.capturedImage = image
        }
    }
}

extension CameraViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if capturedImages.count < 2 {
            let diff = 2 - capturedImages.count
            return capturedImages.count + diff
        } else {
            return capturedImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageCell
        if self.capturedImages.count > indexPath.row {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    cell.photoView.image = strongSelf.capturedImages[indexPath.row]
                }
            }
        }
        cell.layer.cornerRadius = 6
        cell.layer.setCellShadow(contentView: cell.contentView)
        return cell
    }
}
