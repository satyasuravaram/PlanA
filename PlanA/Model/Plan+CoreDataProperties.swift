//
//  Plan+CoreDataProperties.swift
//  PlanA
//
//  Created by Aiden Petratos on 4/2/23.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var numOfActivties: Int64
    @NSManaged public var planDescription: String?
    @NSManaged public var radius: Int64
    @NSManaged public var startDateTime: Date?
    @NSManaged public var listActivities: NSOrderedSet?

}

// MARK: Generated accessors for listActivities
extension Plan {

    @objc(insertObject:inListActivitiesAtIndex:)
    @NSManaged public func insertIntoListActivities(_ value: Activity, at idx: Int)

    @objc(removeObjectFromListActivitiesAtIndex:)
    @NSManaged public func removeFromListActivities(at idx: Int)

    @objc(insertListActivities:atIndexes:)
    @NSManaged public func insertIntoListActivities(_ values: [Activity], at indexes: NSIndexSet)

    @objc(removeListActivitiesAtIndexes:)
    @NSManaged public func removeFromListActivities(at indexes: NSIndexSet)

    @objc(replaceObjectInListActivitiesAtIndex:withObject:)
    @NSManaged public func replaceListActivities(at idx: Int, with value: Activity)

    @objc(replaceListActivitiesAtIndexes:withListActivities:)
    @NSManaged public func replaceListActivities(at indexes: NSIndexSet, with values: [Activity])

    @objc(addListActivitiesObject:)
    @NSManaged public func addToListActivities(_ value: Activity)

    @objc(removeListActivitiesObject:)
    @NSManaged public func removeFromListActivities(_ value: Activity)

    @objc(addListActivities:)
    @NSManaged public func addToListActivities(_ values: NSOrderedSet)

    @objc(removeListActivities:)
    @NSManaged public func removeFromListActivities(_ values: NSOrderedSet)

}

extension Plan : Identifiable {

}
