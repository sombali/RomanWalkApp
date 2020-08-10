//
//  LocationMarkerView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 13..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import MapKit

class LocationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
      willSet {
        
        guard let location = newValue as? MapAnnotation else {
          return
        }
        
        canShowCallout = true
        calloutOffset = CGPoint(x: -5, y: 5)
        markerTintColor = .red
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(12)
        detailLabel.text = location.address?.name
        detailCalloutAccessoryView = detailLabel
        
        
        if let iconImage = location.iconImage {
            glyphImage = iconImage
        } else if let letter = location.title?.first {
            glyphText = String(letter)
        }

      }
    }
}
