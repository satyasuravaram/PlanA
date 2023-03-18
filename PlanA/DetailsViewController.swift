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
    }
    
    @objc func donePressed() {
        if(radius.text == "") {
            radius.text = "10"
        }
        radius.resignFirstResponder()
    }
    
    @IBAction func startDateTimeChanged(_ sender: Any) {
        print(startDateTime.date.description)
    }
    
    
    @IBAction func startPlanButtonPressed(_ sender: Any) {
        // Create alerts if inputs are invalid
        let radiusVal = Int64(radius.text!)
        if (radiusVal == nil || radiusVal! < 1 || radiusVal! > 100) {
            // TODO: make radius alert
        }

        // Create Plan
        plan = Plan(context: self.context)
        plan.updateDetails(newDate: startDateTime.date, newRadius: radiusVal!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     self.view.endEditing(true)
    }


}
