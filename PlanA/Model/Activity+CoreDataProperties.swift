//
//  Activity+CoreDataProperties.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/24/23.
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

}

extension Activity : Identifiable {

}
