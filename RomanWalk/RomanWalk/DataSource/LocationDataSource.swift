//
//  LocationDataSource.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 03..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import CoreData
import SwiftEventBus

protocol LocationDataSourceDelegate: class {
    func dataSource(_ dataSource: LocationDataSource, didFinishFetching locations: [Location])
}

class LocationDataSource: NSObject {
    
    var locations: [Location] = []
    private let managedObjectContext = AppDelegate.managedContext
    var fetchedResultsController: NSFetchedResultsController<Location>!
    weak var delegate: LocationDataSourceDelegate?
    
    override init() {
        super.init()
        fetchLocations()
    }
    
    func fetchLocations() {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        let nameSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Location.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [nameSortDescriptor]
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        fetchRequest.fetchBatchSize = 20
        
        do {
            try fetchedResultsController.performFetch()
            
            if let locations = fetchedResultsController.fetchedObjects {
                self.locations = locations
            }

        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchLocation(for id: String) -> Location? {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let location = try managedObjectContext.fetch(fetchRequest).first
            if let location = location {
                return location
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

//MARK: NSFetchedREsultsControllerDelegate
extension LocationDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let locations = fetchedResultsController.fetchedObjects {
            self.locations = locations
        }
        self.delegate?.dataSource(self, didFinishFetching: self.locations)
    }
}
