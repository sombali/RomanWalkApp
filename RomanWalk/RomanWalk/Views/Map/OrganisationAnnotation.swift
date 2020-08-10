//
//  OrganisationAnnotation.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 13..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import MapKit

class OrganisationAnnotation: NSObject {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var organisation: Organisation?
    var iconImage: UIImage?
    var address: Address?

    init(organisation: Organisation) {
        self.coordinate = CLLocationCoordinate2D(latitude: organisation.latitude, longitude: organisation.longitude)
        self.title = organisation.name
        self.iconImage = UIImage(named: "museum")
        self.address = organisation.address
    }
}

extension OrganisationAnnotation: MapAnnotation { }
