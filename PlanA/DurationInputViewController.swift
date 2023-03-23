//
//  DurationInputViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/23/23.
//

import UIKit

class DurationInputViewController: UIViewController {

    @IBOutlet var addButton: UIButton!
    @IBOutlet var pageTitle: UILabel!
    @IBOutlet var duration: UIDatePicker!
    @IBOutlet var vStack: UIStackView!
    
    var activityName: String = ""
    var currentPlanIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set background and title color
        pageTitle.textColor = .white
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        pageTitle.text = activityName
        vStack.backgroundColor = .white
        view.sendSubviewToBack(vStack)
        
        // set up button
        addButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        addButton.layer.cornerRadius = 10
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.textColor = .white
    }
    
    @IBAction func addButtonPressed() {
        print("Add button was PRESSED")
        let time = duration.countDownDuration
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        print(String(format:"%i:%i", hours, minutes))
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let easvc = storyboard.instantiateViewController(withIdentifier: "editaddact_vc") as! EditAddActViewController
//        easvc.editActivity = false
//        self.navigationController?.pushViewController(easvc, animated: true)
        
        categories[currentPlanIndex-1] = activityName
        durations[currentPlanIndex-1] = String(format:"%i:%i", hours, minutes)
        
        let vc = self.navigationController?.viewControllers.filter({$0 is PlanViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
}
