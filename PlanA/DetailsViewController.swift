//
//  DetailsViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

public var plan = Plan()

class DetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var radius: UITextField!
    @IBOutlet weak var startPlanButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    var leavePage = false
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pageTitle.textColor = .white
        titleView.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        radius.text = "10"
        startDateTime.minimumDate = Date.now
        startPlanButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        startPlanButton.layer.cornerRadius = 10
        startPlanButton.setTitleColor(.white, for: .normal)
        
        // add done button to number pad
        let keypadToolbar: UIToolbar = UIToolbar()
        keypadToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        radius.inputAccessoryView = keypadToolbar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO: if back button is pressed and a plan object was created but did not reach generated plan page, then delete plan object so it does not show up blank on saved plans page
        if(!leavePage && context.hasChanges) {
            if(plan.name == nil) {
                self.context.delete(plan)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leavePage = false
    }
    
    @objc func donePressed() {
        if(radius.text == "") {
            radius.text = "10"
        }
        // Create alerts if inputs are invalid
        let radiusVal = Int64(radius.text!)
        if (radiusVal == nil || radiusVal! < 1 || radiusVal! > 100) {
            // TODO: make radius alert
            let alert = UIAlertController(title: "Invalid Radius:", message: "Please enter a valid radius between 1 mile and 100 miles.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
                self.radius.text = "10"
            }
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        radius.resignFirstResponder()
    }
    
    @IBAction func startDateTimeChanged(_ sender: Any) {
        print(startDateTime.date.description)
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "How to create a plan:", message: "1) Enter the date and time you want to start this plan and the radius to search for activties around your current location.\n2) Click 'Start Plan' to begin building your plan. \n3) Select activities you are interested in, then press generate to create your plan.\n4) You can tap to edit, swipe to delete, and drag to reorder your activites to create the perfect plan.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func startPlanButtonPressed(_ sender: Any) {
        leavePage = true
        
        let radiusVal = Int64(radius.text!)! * 1609 // convert to meters for API

        // Create Plan
        plan = Plan(context: self.context)
        plan.updateDetails(newDate: startDateTime.date, newRadius: radiusVal)
        plan.dateCreated = Date()
        plan.id = UUID()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     self.view.endEditing(true)
    }
}
