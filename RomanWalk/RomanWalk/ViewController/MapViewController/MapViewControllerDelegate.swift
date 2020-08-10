//
//  MapViewControllerDelegate.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 12..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import MapKit

class MapViewControllerDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let coordinate = view.annotation?.coordinate else { return }
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error while reverse geocoding: \(error.localizedDescription)")
            }
            
            guard let placemarks = placemarks, placemarks.count != 0 else { return }
            
            let clPlacemark = placemarks.first!
            let placemark = MKPlacemark(placemark: clPlacemark)
            let mapItem = MKMapItem(placemark: placemark)
            
            mapItem.name = view.annotation?.title!

            var mapItems = [MKMapItem]()
            mapItems.append(MKMapItem.forCurrentLocation())
            mapItems.append(mapItem)

            let launchOptions: [String: Any] = [
                MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
            ]
            MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
        }
    }
}
