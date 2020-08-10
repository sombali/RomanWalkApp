//
//  Location+CoreDataClass.swift
//  
//
//  Created by Somogyi Balázs on 2020. 03. 19..
//
//

import Foundation
import CoreData
import Firebase
import MapKit

public class Location: NSManagedObject, DownloadedImageData {
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
    
    var quizTasks: [Task] {
        return self.quiz?.allObjects as! [Task]
    }
    
    func create(document: QueryDocumentSnapshot) {
        guard let name = document.get("Name") as? String,
                let imageString = document.get("Image") as? String,
                let image = URL(string: imageString),
                let image3DString = document.get("3D_Image") as? String,
                let image3D = URL(string: image3DString),
                let description = document.get("Description") as? String,
                let coordinates = document.get("GPS_Coordinates") as? GeoPoint,
                let numberOfQuestions = document.get("NumberOfQuestions") as? Int
            else { return }
        
        self.name = name
        self.image = image
        self.numberOfQuestions = Int16(numberOfQuestions)
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
        self.image3D = image3D
        self.locationDescription = description
        self.id = document.documentID
        
        if let reconstructionImageString = document.get("ReconstructionImage") as? String,
            let reconstructionImage = URL(string: reconstructionImageString),
            let reconstructionBackgroundImageString = document.get("ReconstructionBackgroundImage") as? String,
            let reconstructionBackgroundImage = URL(string: reconstructionBackgroundImageString) {
            
            self.reconstructionImage = reconstructionImage
            self.reconstructionBackgroundImage = reconstructionBackgroundImage
        }
        
        self.reverseGeoCodeAddress()
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

extension Location {
    struct Diffable: Hashable, DownloadedImageData {
//        let id: UUID
    
        var name: String?
        let address: String?
        let image: URL?
        var fileName: String?

        init(location: Location) {
//            self.id = UUID()
            
            self.name = location.name
            self.address = location.address?.name
            self.image = location.image
            self.fileName = location.fileName
        }
        
        func hash(into hasher: inout Hasher) {
//            hasher.combine(id)
            hasher.combine(name)
            hasher.combine(address)
            hasher.combine(image)
            hasher.combine(fileName)
        }
        
        static func == (lhs: Diffable, rhs: Diffable) -> Bool {
            return lhs.name == rhs.name && lhs.address == rhs.address && lhs.image == rhs.image && lhs.fileName == rhs.fileName
        }
    }
}
