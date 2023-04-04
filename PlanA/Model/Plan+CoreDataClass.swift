//
//  Plan+CoreDataClass.swift
//  PlanA
//
//  Created by Aiden Petratos on 4/3/23.
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
    
    // get full plan
    func getPlanActivties() -> String {
        var planActs = name! + "\n\nStart Date and Time: "
        planActs.append(startDateTime!.description)
        planActs.append("\n\n")
        
        var count = 1
        for act in listActivities! {
            planActs.append(String(count) + ") " + (act as! Activity).name! + "\n")
            planActs.append("Category: " + (act as! Activity).categoryName! + "\n")
            planActs.append("Location: " + (act as! Activity).location! + "\n")
            planActs.append("Duration: " + (act as! Activity).timeSpan! + "\n")
            planActs.append("Business Hours: " + (act as! Activity).businessHours! + "\n\n")
            count+=1
        }
        print(planActs)
        return planActs
    }
}
