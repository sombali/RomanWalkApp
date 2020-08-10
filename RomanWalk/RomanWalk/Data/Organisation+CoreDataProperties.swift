//
//  Organisation+CoreDataProperties.swift
//  
//
//  Created by Somogyi Balázs on 2020. 05. 12..
//
//

import Foundation
import CoreData


extension Organisation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organisation> {
        return NSFetchRequest<Organisation>(entityName: "Organisation")
    }

    @NSManaged public var address: Address?
    @NSManaged public var fileName: String?
    @NSManaged public var id: String?
    @NSManaged public var image: URL?
    @NSManaged public var image3D: URL?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var museumDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var priceList: String?
    @NSManaged public var socialMedia: String?
    @NSManaged public var website: URL?
    @NSManaged public var icon: URL?
    @NSManaged public var iconName: String?
    @NSManaged public var projects: NSSet?

}

// MARK: Generated accessors for projects
extension Organisation {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}
