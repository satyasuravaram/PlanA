//
//  PlanModel.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/25/23.
//

import Foundation

class Plan {
    
    // variables
    var name:String?
    var description:String?
    // default starting date and time set to current time
    var startDate = Date()
    var startHour = Calendar.current.component(.hour, from: Date())
    var startMinute = Calendar.current.component(.minute, from: Date())
    // default radius
    var radius = 10
    var numberOfActs = 0
    var listActs: [Activity] = []
    // metadata
    var id = UUID()
    var dateCreated = Date()
    
    
    // update the detail variables if default values are changed
    func updateDetails(newDate: Date, newHour: Int, newMinute: Int, newRadius: Int) {
        startDate = newDate
        startHour = newHour
        startMinute = newMinute
        radius = newRadius
    }
    
    // set the name and descitiption of the plan
    func setPlanInfo(planName: String, planDesc: String) {
        name = planName
        description = planDesc
    }
    
    // appends new activity to end of list and increases count
    func addActivity(newAct: Activity) {
        listActs.append(newAct)
        numberOfActs += 1
    }
    
    // sets listAct to passed in list and updates count
    func setAllActivities(listOfActs: [Activity]) {
        listActs = listOfActs
        numberOfActs = listOfActs.count
    }
    
    // prints all the activties in the plan
    func printActs() {
        var count = 1
        for act in listActs {
            print(String(count) + ") " + act.actDetails() + "\n\n")
            count+=1
        }
    }
}
