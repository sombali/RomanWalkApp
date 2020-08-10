//
//  Project+CoreDataClass.swift
//  
//
//  Created by Somogyi Balázs on 2020. 03. 19..
//
//

import Foundation
import CoreData
import Firebase

public class Project: NSManagedObject, DownloadedImageData {
    func create(document: DocumentSnapshot) {
        guard let name = document.get("Name") as? String,
            let imageString = document.get("Image") as? String,
            let image = URL(string: imageString)
            else { return }
        
        self.name = name
        self.image = image
        self.id = document.documentID
    }
}
