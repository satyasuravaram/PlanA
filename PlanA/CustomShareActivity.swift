//
//  CustomActivity.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/19/23.
//

import UIKit

class CustomShareActivity: UIActivity {
     
    //Returns custom activity title
    override var activityTitle: String?{
        return "Save plan in app"
        // return "Add to Saved Plans"
    }
    
    //Returns thumbnail image for the custom activity
    override var activityImage: UIImage?{
        //return UIImage(named: "AppIcon")
        return UIImage(systemName: "square.and.arrow.down")
    }

    //Default is UIActivityCategoryAction
    override class var activityCategory: UIActivity.Category{
        //return .share
        return .action
    }
 
    //Custom activity type that is reported to completionHandler
    override var activityType: UIActivity.ActivityType{
        return UIActivity.ActivityType.customActivity
    }
 
    //View controller for the activity
    override var activityViewController: UIViewController?{
        print("user did tap on my activity")
        return nil
    }
    
    //Returns a Boolean indicating whether the activity can act on the specified data items.
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    //If no view controller, this method is called. call activityDidFinish when done.
    override func prepare(withActivityItems activityItems: [Any]) {
        //Perform action on tap of custom activity
        print("WAS CLICKED")
    }
}

extension UIActivity.ActivityType {
    static let customActivity = UIActivity.ActivityType("<app bundle id>.customShareActivity")
}
