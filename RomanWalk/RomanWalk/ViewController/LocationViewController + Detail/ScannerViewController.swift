//
//  ScannerViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 26..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, Storyboarded {
    
    @IBOutlet weak var scannerView: ScannerView!
    @IBOutlet weak var infoBarButton: UIBarButtonItem!

    weak var coordinator: LocationCoordinator?
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerView.delegate = self
        
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: 
            self.showInstructions()
            self.scannerView.startScanning()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.showInstructions()
                    self.scannerView.startScanning()
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        case .denied, .restricted:
            showCameraNotEnabled()
        @unknown default:
            showCameraNotEnabled()
        }
    }

    func failed() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func showInstructions() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Találd meg a helyszínen elhelyezett táblát és olvasd le az ott látható QR kódot!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func showWrongQRCode() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Hoppá", message: "Nem ez a megfelelő QR kód!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Újrapróbálkozás", style: .default) { (action) in
                self.scannerView.startScanning()
            }
            ac.addAction(action)
            self.present(ac, animated: true)
        }
    }
    
    func showCameraNotEnabled() {
        let ac = UIAlertController(title: nil, message: "A kamera hozzáférését engedélyezned kell a továbblépéshez", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Beállítások", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        ac.addAction(settingsAction)
        ac.addAction(okAction)
        present(ac, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (scannerView.isRunning == false) {
            scannerView.startScanning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (scannerView.isRunning == true) {
            scannerView.stopScanning()
        }
    }

    func found(code: String) -> Bool {
        guard let id = location?.id else { return false }
        
        if code == id.trimmingCharacters(in: .whitespaces) {
            return true
        } else {
            return false
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func infoBarButtonTouched(_ sender: Any) {
        showInstructions()
    }
    
}

extension ScannerViewController: ScannerViewDelegate {
    func scanningDidFail() {
        failed()
    }
    
    func scanningSucceededWithCode(_ str: String?) {
        if let str = str {
            if found(code: str) {
                if let tasks = location?.quizTasks, let maxQuestionNumber = location?.numberOfQuestions {
                    coordinator?.show(tasks, for: location?.name, Int(maxQuestionNumber))
                }
            } else {
                showWrongQRCode()
            }
        }
    }
}
