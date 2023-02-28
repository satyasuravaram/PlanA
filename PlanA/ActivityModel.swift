//
//  ActivityModel.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/25/23.
//

import Foundation

class Activity {
    
    // variables
    var name:String?
    var description:String?
    var location:String?
    var duration:Int?
    var categoryName:String?
    
    // returns a string with all the activity's details
    func actDetails() -> String {
        return name! + ": " + description! + "\nAddress: " + location! + "\nDuration: " + String(duration!) + "\nCategory: " + categoryName!
    }
}
