//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Somogyi Balázs on 2020. 05. 05..
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: Address?
    @NSManaged public var fileName: String?
    @NSManaged public var id: String?
    @NSManaged public var image: URL?
    @NSManaged public var image3D: URL?
    @NSManaged public var latitude: Double
    @NSManaged public var locationDescription: String?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var numberOfQuestions: Int16
    @NSManaged public var reconstructionBackgroundImage: URL?
    @NSManaged public var reconstructionBackgroundImageName: String?
    @NSManaged public var reconstructionImage: URL?
    @NSManaged public var reconstructionImageName: String?
    @NSManaged public var website: String?
    @NSManaged public var icon: URL?
    @NSManaged public var iconName: String?
    @NSManaged public var project: Project?
    @NSManaged public var quiz: NSSet?

}

// MARK: Generated accessors for quiz
extension Location {

    @objc(addQuizObject:)
    @NSManaged public func addToQuiz(_ value: Task)

    @objc(removeQuizObject:)
    @NSManaged public func removeFromQuiz(_ value: Task)

    @objc(addQuiz:)
    @NSManaged public func addToQuiz(_ values: NSSet)

    @objc(removeQuiz:)
    @NSManaged public func removeFromQuiz(_ values: NSSet)

}
