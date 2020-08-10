//
//  OrganisationDataSource.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 07..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import CoreData
import SwiftEventBus

class OrganisationDataSource {
    var organisation: [Organisation]
    
    private let managedObjectContext = AppDelegate.managedContext
    
    init() {
        organisation = [Organisation]()
        fetchOrganisation()
        
    }
    
    private func fetchOrganisation() {
        let organisationID = UserDefaults.standard.object(forKey: "OrganisationID") as? String
        
        let fetchRequest: NSFetchRequest<Organisation> = Organisation.fetchRequest()
        if let organisationID = organisationID {
            fetchRequest.predicate = NSPredicate(format: "id == %@", organisationID)
            
            do {
                organisation = try managedObjectContext.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
