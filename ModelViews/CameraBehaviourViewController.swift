//
//  CameraBehaviourViewController.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/26.
//

import UIKit
import AVFoundation

// MARK: Functions in this class must in the viewModel File and the constants and variables must be in the ViewCOntroller

class CameraBehaviourViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    
    var previewLayer: CALayer!
    var captureDevice: AVCaptureDevice!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
        // Do any additional setup after loading the view.
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availableDevices
        }
    }

    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) 
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
        
    }
}
