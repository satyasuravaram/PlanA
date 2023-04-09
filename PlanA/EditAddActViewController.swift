//
//  EditADdActViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/21/23.
//

import UIKit

class EditAddActViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var directionsButton: UIButton!
    @IBOutlet var pageTitle: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var duration: UIDatePicker!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var chosenActivityName: UITextField!
    @IBOutlet var chosenAddress: UITextField!
    @IBOutlet var vStack: UIStackView!

    var editActivity: Bool = false
    var activityName: String = ""
    var actDesc: String = ""
    var address: String = ""
    var seconds: Int!
    var index: Int!
    var didSelectPlan = false
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set background and title color
        pageTitle.textColor = .white
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        if self.traitCollection.userInterfaceStyle == .dark {
            vStack.backgroundColor = .black
        } else {
            vStack.backgroundColor = .white
        }
        view.sendSubviewToBack(vStack)
        
        // set up button
        doneButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        doneButton.layer.cornerRadius = 10
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.textColor = .white
       
        if(editActivity) {
            // edit acitivty view
            pageTitle.text = (didSelectPlan) ? "Activity" : "Edit Activity"
            chosenAddress.isHidden = true
            chosenActivityName.isHidden = true
            directionsButton.isHidden = (actDesc == "Added Activity")
            doneButton.titleLabel?.text = "Done"
            doneButton.titleLabel?.textColor = .white
            activityLabel.text = "Activity:\t" + activityName
            addressLabel.text = "Location:\t" + address
            duration.countDownDuration = TimeInterval(seconds)
            
            if(didSelectPlan) {
                doneButton.isHidden = true
                duration.isEnabled = false
            } else {
                doneButton.isHidden = false
                duration.isEnabled = true
            }
            
        } else {
            // add activity view
            pageTitle.text = "Add Activity"
            activityLabel.text = "Activity:"
            addressLabel.text = "Address:"
            chosenAddress.isHidden = false
            chosenActivityName.isHidden = false
            chosenAddress.isEnabled = true
            chosenActivityName.isEnabled = true
            directionsButton.isHidden = true
            doneButton.titleLabel?.text = "Add"
            doneButton.titleLabel?.textColor = .white
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chosenAddress.resignFirstResponder()
        chosenActivityName.resignFirstResponder()
        return true
    }
    
    @IBAction func doneButtonPressed() {
        print("finsihed")
        if(editActivity) {
            // modify activity in plan
            if(seconds != Int(duration.countDownDuration)) {
                let activityMod = activities[index]
                activityMod.duration = Double(duration.countDownDuration)
                planDidChange = true
                plan.listActivities = NSOrderedSet(array: activities)
            }
        } else {
            // add activity into plan
            let activity:Activity = Activity(context: self.context)
            activity.name = (chosenActivityName.text == "") ? "Added Activity" : chosenActivityName.text
            activity.location = chosenAddress.text
            activity.duration = Double(duration.countDownDuration)
            activity.actDescription = "Added Activity"
            activity.categoryName = "none"
            activity.businessHours = ""
            let newIndex = (index-1)/2 + 1
            activities.insert(activity, at: newIndex)
            plan.listActivities = NSOrderedSet(array: activities)
            //plan.listActs = activities
            plan.numOfActivties += 1
            planDidChange = true
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func directionsButtonPressed() {
        
        if (address == "No location found") {
            return
        }
        
        print("Get directions")
        let locationArr = address.split(separator: ",")
        let lat = locationArr[0].replacingOccurrences(of: "(", with: "")
        let lng = locationArr[1].replacingOccurrences(of: ")", with: "")
        
        // open google maps in safari
        if let url = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
            UIApplication.shared.open(url)
        }
    }
}
