//
//  Plan+CoreDataClass.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/2/23.
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
    
    // appends new activity to end of list and increases count
    func addActivity(newAct: Activity) {
        listActs?.append(newAct)
        numOfActivties += 1
    }
    
    // sets listAct to passed in list and updates count
    func setAllActivities(listOfActs: [Activity]) {
        listActs = listOfActs
        numOfActivties = Int64(listOfActs.count)
    }
    
    // prints all the activties in the plan
    func printActs() {
        var count = 1
        for act in listActs! {
            print(String(count) + ") " + act.actDetails() + "\n\n")
            count+=1
        }
    }
}
