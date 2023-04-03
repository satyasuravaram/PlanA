//
//  Plan+CoreDataClass.swift
//  PlanA
//
//  Created by Aiden Petratos on 4/2/23.
//
//

import Foundation
import CoreData

@objc(Plan)
public class Plan: NSManagedObject {
    
    // update the detail variables if default values are changed
    func updateDetails(newDate: Date, newRadius: Int64) {
        startDateTime = newDate
        radius = newRadius
    }
    
    // set the name and descitiption of the plan
    func setPlanInfo(planName: String, planDesc: String) {
        name = planName
        planDescription = planDesc
    }
    
    // prints all the activties in the plan
    func printActs() {
        var count = 1
        for act in listActivities! {
            print(String(count) + ") " + (act as! Activity).actDetails() + "\n\n")
            count+=1
        }
    }
}
