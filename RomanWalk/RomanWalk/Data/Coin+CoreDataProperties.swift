//
//  Coin+CoreDataProperties.swift
//  
//
//  Created by Somogyi Balázs on 2020. 04. 18..
//
//

import Foundation
import CoreData


extension Coin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coin> {
        return NSFetchRequest<Coin>(entityName: "Coin")
    }

    @NSManaged public var collected: Bool
    @NSManaged public var discount: Double
    @NSManaged public var fileName: String?
    @NSManaged public var image: URL?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var project: Project?

}
