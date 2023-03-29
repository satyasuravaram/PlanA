//
//  EditADdActViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/21/23.
//

import UIKit

class EditAddActViewController: UIViewController {
    
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
    var address: String = ""
    var seconds: Int!
    
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
        
        // add done button to keyboard
        let keypadToolbar: UIToolbar = UIToolbar()
        keypadToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneTyping))
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the keyboard
        chosenActivityName.inputAccessoryView = keypadToolbar
        chosenAddress.inputAccessoryView = keypadToolbar
       
        if(editActivity) {
            // edit acitivty view
            pageTitle.text = "Edit Activity"
            chosenAddress.isHidden = true
            chosenActivityName.isHidden = true
            directionsButton.isHidden = false
            doneButton.titleLabel?.text = "Done"
            doneButton.titleLabel?.textColor = .white
            activityLabel.text = "Activity:\t" + activityName
            addressLabel.text = "Address:\t" + address
            duration.countDownDuration = TimeInterval(seconds)
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

    @IBAction func doneButtonPressed() {
        print("finsihed")
    }
    
    @IBAction func directionsButtonPressed() {
        print("Get directions")
        let locationArr = address.split(separator: ",")
        let lat = locationArr[0].replacingOccurrences(of: "(", with: "")
        let lng = locationArr[1].replacingOccurrences(of: ")", with: "")
        
        // open google maps in safari
        if let url = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func doneTyping() {
        chosenAddress.resignFirstResponder()
        chosenActivityName.resignFirstResponder()
    }
}
