//
//  Activity+CoreDataClass.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/24/23.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    
    func actDetails() -> String {
        return name! + ": " + description + "\nAddress: " + location! + "\nDuration: " + String(duration) + "\nCategory: " + categoryName! + "\nBusiness Hours: " + businessHours!
    }
}
