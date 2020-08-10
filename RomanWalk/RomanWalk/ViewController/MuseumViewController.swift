//
//  MuseumViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import MapKit
import WebKit

class MuseumViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MuseumCoordinator?
    
    var organisation: Organisation?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var museumDescription: UITextViewFixed!
    @IBOutlet weak var website: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let organisationDataSource = OrganisationDataSource()
        organisation = organisationDataSource.organisation.first
        
        if let organisation = organisation {
            navigationItem.title = organisation.name
            name.text = organisation.name
            imageView.loadImage(for: organisation)
            museumDescription.text = organisation.museumDescription
            website.setTitle(organisation.website?.absoluteString, for: .normal)
            if let addressString = organisation.addressString {
                location.text = addressString
            }
        }
    }

    @IBAction func onWebsiteButtonTouchUpInside(_ sender: Any) {
        if let url = organisation?.website {
            coordinator?.openWeb(url: url)
        }
    }
}
