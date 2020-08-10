//
//  LocationDetailViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import MapKit
import SwiftMessages

class LocationDetailViewController: UIViewController, Storyboarded {
    
    weak var coordinator: LocationCoordinator?
    
    var location: Location? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var textView: UITextViewFixed!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationButton.layer.cornerRadius = 10
        navigationButton.clipsToBounds = true
        quizButton.layer.cornerRadius = 10
        quizButton.clipsToBounds = true
        ARButton.layer.cornerRadius = 10
        ARButton.clipsToBounds = true
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let location = location {
            navigationItem.title = location.name
            
            self.imageView.loadImage(for: location)
            self.name.text = location.name
            self.textView.text = location.locationDescription
            if let addressString = location.addressString {
                self.address.text = addressString
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchHandler(sender:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func touchHandler(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onQuizButtonTapped(_ sender: Any) {
        if let location = location {
            coordinator?.openQRScanner(for: location)
        }
    }
    
    @IBAction func onARButtonTapped(_ sender: Any) {
        guard let location = location else { return }
        
        let reconstructionButtonHandler: (() -> Void)? = {
            self.hideMessage()
            self.coordinator?.showReconstruction(for: location)
        }
        
        let arButtonHandler: (() -> Void)? = {
            self.hideMessage()
            self.coordinator?.showAR(for: location)
        }
        
        self.showTwoButtonWithTitleMessageView(title: "Válaszd ki hogyan szeretnéd megnézni!", firstButtonTitle: "Rekonstrukciós nézet", secondButtonTitle: "AR nézet", firstButtonHandler: reconstructionButtonHandler, secondButtonHandler: arButtonHandler)
    }
    
    @IBAction func routePlannerButtonTapped(_ sender: Any) {
        guard let location = location else { return }
        
        let appleMaps: (() -> Void)? = {
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
            let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), addressDictionary: nil)
           
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = location.name
            mapItem.openInMaps(launchOptions: options)
        }
        let googleMaps: (() -> Void)? = {
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        showTwoButtonWithTitleMessageView(title: "Tervezd meg az útvonalat!", firstButtonTitle: "Apple maps", secondButtonTitle: "Google maps", firstButtonHandler: appleMaps, secondButtonHandler: googleMaps)
    }
    
}
