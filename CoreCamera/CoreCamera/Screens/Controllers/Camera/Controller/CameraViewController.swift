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
import Photos

protocol CameraViewControllerDelegate: class {
    func navigateToAlbum(for images: [UIImage])
}

final class CameraViewController: UIViewController, Controller {
    
    weak var delegate: CameraViewControllerDelegate?
    var type: ControllerType = .camera
    private let cameraShutterSoundID: SystemSoundID = 1108
    
    // MARK: - Properties
    
    @IBOutlet weak private var filterButton: UIButton!
    @IBOutlet weak private var videoView: UIImageView!
    
    private var capturedImage: UIImage!
    private var capturedImages: [UIImage] = []
    
    internal var bottomMenu = BottomMenu()
    
    @IBOutlet weak private var cameraView: UIView!
    
    private lazy var buttonLayer: CALayer = {
        let layer = CALayer.createButton()
        layer.opacity = 0
        self.cameraView.layer.addSublayer(layer)
        return layer
    }()
    
    private var camera: Camera!
    private var picker = UIImagePickerController()
    private var photoButtonEnabled: Bool = true
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let invertColorFilter = CIFilter(name: "CIColorInvert")
    private let comicFilter = CIFilter(name: "CIComicEffect")
    private let glassDistortionFilter = CIFilter(name: "CISepiaTone")
    private let twirlDistortionFilter = CIFilter(name: "CITwirlDistortion")
    private var flashLayer: CALayer?
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera = Camera()
        camera.delegate = self
        setupButton()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setup() {
        print("setup")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.bounds = cameraView.frame
        filterButton.tintColor = .white
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
            let touch: UITouch = touches.first! as UITouch
            let touchLocation = touch.location(in: self.cameraView)
            let buttonLayerFrame = buttonLayer.frame
            if buttonLayerFrame.contains(touchLocation) {
                addAnimations()
                takePhoto(tapped: true)
            }
        } else {
            print("enable photo")
        }
    }
    
    private func flashScreen() {
        let flash = CALayer()
        flash.frame = view.bounds
        flash.backgroundColor = UIColor.white.cgColor
        view.layer.addSublayer(flash)
        flash.opacity = 0
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.1
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        flash.add(animation, forKey: "flashAnimation")
        self.flashLayer = flash
    }
    
    private func setupButtonLayer() {
        buttonLayer.opacity = 1
        buttonLayer.cornerRadius = buttonLayer.frame.width / 2
        buttonLayer.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.2)
        buttonLayer.borderWidth = 4.0
        buttonLayer.borderColor = UIColor.white.cgColor
        buttonLayer.shadowOpacity = 0.2
        buttonLayer.shadowOffset = CGSize(width: 0, height: 3)
        buttonLayer.shadowRadius = 3.0
        let image = #imageLiteral(resourceName: "lightning-small").withRenderingMode(.alwaysTemplate)
        filterButton.setImage(image, for: .normal)
        filterButton.tintColor = .white
    }
    
    private func addAnimations() {
        flashScreen()
        AudioServicesPlaySystemSound(cameraShutterSoundID)
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
        }
    }
    
    private func displayRect(rect: CGRect) {
        buttonLayer.frame = rect
        setupButtonLayer()
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
        dump(capturedImages)
        delegate?.navigateToAlbum(for: capturedImages)
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
        filterButton.tintColor = .blue
        camera.currentFilter = glassDistortionFilter
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

extension CameraViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        flashLayer?.removeFromSuperlayer()
        flashLayer = nil
    }
}
