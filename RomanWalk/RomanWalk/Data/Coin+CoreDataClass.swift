//
//  Coin+CoreDataClass.swift
//  
//
//  Created by Somogyi Balázs on 2020. 03. 19..
//
//

import Foundation
import CoreData
import Firebase


public class Coin: NSManagedObject, DownloadedImageData {
    func create(document: QueryDocumentSnapshot) {
        guard let name = document.get("Name") as? String,
                let imageString = document.get("Image") as? String,
                let image = URL(string: imageString),
            let discount = document.get("Discount") as? Double,
            let locationName = document.get("LocationName") as? String
            else { return }
        
        self.name = name
        self.fileName = name
        self.image = image
        self.location = locationName
        self.discount = discount
        self.collected = false
    }
}
