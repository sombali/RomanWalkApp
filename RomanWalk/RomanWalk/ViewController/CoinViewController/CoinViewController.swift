//
//  CoinViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 21..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import Kingfisher
import Reachability

class CoinViewController: UIViewController, Storyboarded {
    weak var coordinator: CoinCoordinator?
    let reachability = try! Reachability()
    var hasNetwork: Bool?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var optionsBarButtonItem: UIBarButtonItem!
    
    let dataHandler = CoinCollectionViewDataHandler()
    let numberOfItemsPerRow: CGFloat = 3
    let interItemSpacing: CGFloat = 10
    
    let sideSpacing = CGFloat(20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "background");
        bgImage.contentMode = .scaleToFill
        self.collectionView.backgroundView = bgImage
        
        dataHandler.delegate = self
        
        collectionView.dataSource = dataHandler
        collectionView.delegate = dataHandler
        
        collectionView.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: CoinCollectionViewCell.reuseIdentifier)
        collectionView.register(CoinStaticCollectionViewCell.self, forCellWithReuseIdentifier: CoinStaticCollectionViewCell.reuseIdentifier)
        collectionView.register(CoinTitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CoinTitleSupplementaryView.reuseIdentifier)
        
        startReachabilityNotifier()
        setNetworkStatus()
    }
    
    //MARK: Network check
    fileprivate func startReachabilityNotifier() {

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    fileprivate func setNetworkStatus() {
        reachability.whenUnreachable = { _ in
            self.hasNetwork = false
        }
        
        reachability.whenReachable = { _ in
            self.hasNetwork = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        reachability.stopNotifier()
    }
    
    //MARK: Post to firebase
    fileprivate func postQRCodeToFirebase(_ defaults: UserDefaults, _ percentage: Int, _ gameID: String, _ organisationID: String, _ projectID: String, _ qrCodeString: String) {
        guard let hasNetwork = hasNetwork else {
            self.showSimpleMessage(title: "Hiba történt", body: "Kérlek próbáld újra!", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, with: nil, theme: .error)
            return
        }
        
        var projectAndQRCode = defaults.object(forKey: "QRCode") as? [String: String] ?? [String: String]()
        
        if hasNetwork {
            let firebaseService = FirebaseService()
            firebaseService.post(percentage: percentage, gameID: gameID, organisationID: organisationID, projectID: projectID) { (result) -> (Void) in
                switch result {
                case .success():
                    projectAndQRCode.updateValue(qrCodeString, forKey: projectID)

                    defaults.set(projectAndQRCode, forKey: "QRCode")
                    self.showSimpleMessage(title: "Gratulálunk", body: "Irány a múzeum!", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, with: nil, theme: .success)
                case .failure(_):
                    self.showSimpleMessage(title: "Hiba történt", body: "Kérlek próbáld újra!", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, with: nil, theme: .error)
                }
            }
        } else {
            self.showSimpleMessage(title: "Hálózati hiba történt!", body: "Kérlek próbáld újra később", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, with: nil, theme: .error)
        }
    }
    
    //MARK: Options button pressed
    @IBAction func onOptionsBarButtonItemTouch(_ sender: Any) {
        let redeem: (() -> Void)? = {
            self.hideMessage()

            let defaults = UserDefaults.standard
            
            let gameID = defaults.object(forKey: "GameID") as? String
            let projectID = defaults.object(forKey: "ProjectID") as? String
            let organisationID = defaults.object(forKey: "OrganisationID") as? String
            let percentage = self.dataHandler.percentage
            
            if let gameID = gameID, let projectID = projectID, let organisationID = organisationID {
                if percentage != 0 {
                    let qrCodeString = "\(organisationID);\(projectID);\(gameID);\(String(percentage))"
                    
                    self.postQRCodeToFirebase(defaults, percentage, gameID, organisationID, projectID, qrCodeString)
                } else {
                    self.showSimpleMessage(title: "Ajaj", body: "0%-ra nem jár kedvezmény", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, with: nil, theme: .warning)
                }
            }
        }
        
        let inspect: (() -> Void)? = {
            self.hideMessage()
            
            let defaults = UserDefaults.standard
            let projectID = defaults.object(forKey: "ProjectID") as? String
            let projectAndQRCode = defaults.object(forKey: "QRCode") as? [String: String]

            if let projectID = projectID,
                let projectAndQRCode = projectAndQRCode,
                let qrCodeString = projectAndQRCode[projectID] {
                
                let qrCodeImage = self.generateQRCode(from: qrCodeString)
                
                if let qrCodeImage = qrCodeImage {
                    self.coordinator?.presentQRCodeViewController(qrCodeImage, qrCodeString)
                }
            } else {
                self.showSimpleMessage(title: "Ne ilyen gyorsan", body: "Jelenleg még nem generáltál QR kódot", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, with: nil, theme: .info)
            }
        }
        showQRCodeMenu(redeem: redeem, inspect: inspect)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

//MARK: CoinCollectionViewChangeDelegate
extension CoinViewController: CoinCollectionViewChangeDelegate {
    func dataSourceShouldReload() {
        collectionView.reloadData()
    }
}
