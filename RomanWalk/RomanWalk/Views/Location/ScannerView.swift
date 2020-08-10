//
//  ScannerView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 26..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerViewDelegate: class {
    func scanningDidFail()
    func scanningSucceededWithCode(_ str: String?)
}

class ScannerView: UIView {
    
    weak var delegate: ScannerViewDelegate?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
}

extension ScannerView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
       
    func startScanning() {
        captureSession?.startRunning()
    }

    func stopScanning() {
        captureSession?.stopRunning()
    }
    
    func setupView() {
        backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)

        startScanning()
    }
    
    func failed() {
        delegate?.scanningDidFail()
        captureSession = nil
    }
}

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopScanning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    func found(code: String) {
        delegate?.scanningSucceededWithCode(code)
    }
}
