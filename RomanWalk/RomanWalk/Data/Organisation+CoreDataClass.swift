//
//  Organisation+CoreDataClass.swift
//  
//
//  Created by Somogyi Balázs on 2020. 03. 19..
//
//

import Foundation
import CoreData
import Firebase
import MapKit

public class Organisation: NSManagedObject, DownloadedImageData {
    
    var coordinate: (latitude: Double, longitude: Double) {
        return (latitude, longitude)
    }
    
    var addressString: String? {
        if let address = address {
            return "\(address.administrativeArea), \(address.name), \(address.postalCode) \(address.country)"
        } else {
            return nil
        }
    }
    
    func create(document: QueryDocumentSnapshot) {
        guard let name = document.get("Name") as? String,
                let imageString = document.get("Image") as? String,
                let image = URL(string: imageString),
                let museumDescription = document.get("Description") as? String,
                let websiteString = document.get("Website") as? String,
                let website = URL(string: websiteString),
                let coordinates = document.get("GPS_Coordinates") as? GeoPoint
            else { return }
        
        self.name = name
        self.id = document.documentID
        self.image = image
        self.fileName = name
        self.museumDescription = museumDescription
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
        self.website = website
        
        reverseGeoCodeAddress()
    }
    
    func reverseGeoCodeAddress() {
        let geocoder = CLGeocoder()
                    
        geocoder.reverseGeocodeLocation(CLLocation(latitude: self.latitude, longitude: self.longitude),
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                if let firstLocation = firstLocation,
                    let administrativeArea = firstLocation.administrativeArea,
                    let name = firstLocation.name,
                    let postalCode = firstLocation.postalCode,
                    let country = firstLocation.country {
                        self.address = Address(administrativeArea: administrativeArea, name: name, postalCode: postalCode, country: country)
                }
            }
            else {
                print("Error while reverse geocoding")
            }
        })
    }
}
