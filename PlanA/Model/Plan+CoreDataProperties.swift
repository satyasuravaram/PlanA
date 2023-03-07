//
//  Plan+CoreDataProperties.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/2/23.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var radius: Int64
    @NSManaged public var planDescription: String?
    @NSManaged public var startDateTime: Date?
    @NSManaged public var numOfActivties: Int64
    @NSManaged public var listActs: [Activity]?
    @NSManaged public var id: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String?

}

extension Plan : Identifiable {

}
