//
//  CameraEngine.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage
import UIKit

protocol CameraDelegate: class {
    func update(image: UIImage)
}

class Camera: NSObject {
    
    weak var delegate: CameraDelegate?
   
    var filtering: Bool = false
    var currentFilter: CIFilter!
    
    private var dataOutput: AVCaptureVideoDataOutput?

    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let sampleBufferQueue = DispatchQueue.global(qos: .userInteractive)

    private let context: CIContext = {
        let eaglContext = EAGLContext(api: .openGLES2)
        return CIContext(eaglContext: eaglContext!)
    }()
    
    override init() {
        super.init()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .restricted, .denied, .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authorized in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    if authorized {
                        strongSelf.setupCaptureSession()
                    }
                }
            }
        }
    }
    
    private func setupPreview() {
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.backgroundColor = UIColor.black.cgColor
        preview.videoGravity = .resizeAspect
        previewLayer = preview
    }
    
    private func setupOutput() {
        dataOutput = AVCaptureVideoDataOutput()
        guard let output = dataOutput else { return }
        
        output.videoSettings = [
            String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        ]
        
        output.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        guard let connection = output.connection(with: AVFoundation.AVMediaType.video) else { return }
        connection.videoOrientation = .portrait
        captureSession.commitConfiguration()
        output.setSampleBufferDelegate(self, queue: sampleBufferQueue)
    }
    
    private func setupCaptureSession() {
        
        guard captureSession.inputs.isEmpty else { return }
        
        let types: [AVCaptureDevice.DeviceType] = [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera]
        let discovered = AVCaptureDevice.DiscoverySession(deviceTypes: types, mediaType: .video, position: .back)
        
        guard let camera = discovered.devices.first else { print("No camera found"); return }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(cameraInput)
            setupPreview()
            setupOutput()
            captureSession.startRunning()
            
        } catch let error {
            print("Error creating session: \(error.localizedDescription)")
            return
        }
    }
}

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let image = CIImage(cvImageBuffer: imageBuffer)
        
        if !filtering {
            let filteredImage = UIImage(ciImage: image)
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.delegate?.update(image: filteredImage)
                }
            }
        } else {
            currentFilter.setValue(image, forKey: kCIInputImageKey)
            if let outputImg = currentFilter.value(forKey: kCIOutputImageKey) as? CIImage {
                let filteredImage = UIImage(ciImage: outputImg)
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        strongSelf.delegate?.update(image: filteredImage)
                    }
                }
            }
        }
    }
}
