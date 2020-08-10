//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Somogyi Balázs on 2020. 04. 08..
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var answer: String?
    @NSManaged public var id: String?
    @NSManaged public var options: [String]?
    @NSManaged public var question: String?
    @NSManaged public var location: Location?

}
