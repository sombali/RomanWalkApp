//
//  Project+CoreDataProperties.swift
//  
//
//  Created by Somogyi Balázs on 2020. 04. 26..
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: URL?
    @NSManaged public var name: String?
    @NSManaged public var version: String?
    @NSManaged public var fileName: String?
    @NSManaged public var coins: NSSet?
    @NSManaged public var locations: NSSet?
    @NSManaged public var organisation: Organisation?

}

// MARK: Generated accessors for coins
extension Project {

    @objc(addCoinsObject:)
    @NSManaged public func addToCoins(_ value: Coin)

    @objc(removeCoinsObject:)
    @NSManaged public func removeFromCoins(_ value: Coin)

    @objc(addCoins:)
    @NSManaged public func addToCoins(_ values: NSSet)

    @objc(removeCoins:)
    @NSManaged public func removeFromCoins(_ values: NSSet)

}

// MARK: Generated accessors for locations
extension Project {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
