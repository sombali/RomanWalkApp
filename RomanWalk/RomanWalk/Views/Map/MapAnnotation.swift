//
//  MapAnnotation.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 13..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import MapKit

protocol MapAnnotation: MKAnnotation {
    var title: String? { get }
    var coordinate: CLLocationCoordinate2D { get }
    var mapItem: MKMapItem? { get }
    var iconImage: UIImage? { get }
    var address: Address? { get }
}

extension MapAnnotation {
    var mapItem: MKMapItem? {
           let placemark = MKPlacemark(coordinate: coordinate)
           let mapItem = MKMapItem(placemark: placemark)
           mapItem.name = title
           return mapItem
       }
}
