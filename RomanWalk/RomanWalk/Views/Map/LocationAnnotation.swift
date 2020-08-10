//
//  LocationAnnotation.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 07..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var location: Location?
    var iconImage: UIImage?
    var address: Address?

    init(location: Location) {
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.title = location.name
        self.iconImage = UIImage(named: "colosseum")
        self.address = location.address
    }
}

extension LocationAnnotation: MapAnnotation { }
