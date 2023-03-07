//
//  Activity+CoreDataClass.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/2/23.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {

    // returns a string with all the activity's details
    func actDetails() -> String {
        return name! + ": " + description + "\nAddress: " + location! + "\nDuration: " + String(duration) + "\nCategory: " + categoryName! + "\nBusiness Hours: " + businessHours!
    }
}
