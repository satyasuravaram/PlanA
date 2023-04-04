//
//  Activity+CoreDataClass.swift
//  PlanA
//
//  Created by Aiden Petratos on 4/3/23.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {

    func actDetails() -> String {
        return name! + ": " + "\nAddress: " + location! + "\nDuration: " + timeSpan! + "\nCategory: " + categoryName! + "\nBusiness Hours: " + businessHours!
    }
}
