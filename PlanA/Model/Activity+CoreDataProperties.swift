//
//  Activity+CoreDataProperties.swift
//  PlanA
//
//  Created by Aiden Petratos on 4/3/23.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var actDescription: String?
    @NSManaged public var businessHours: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var duration: Double
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var timeSpan: String?
    @NSManaged public var plan: Plan?

}

extension Activity : Identifiable {

}
