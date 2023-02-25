//
//  ViewController.swift
//  PlanA
//
//  Created by Satya Suravaram on 2/3/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var savedPlanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Home page")
    }
    
//    @IBAction func buttonPressed() {
//        print("Button pressed")
//        let vc = storyboard?.instantiateViewController(identifier: "savedplans_vc") as! SavedPlanViewController
//        present(vc, animated: false)
//    }

}

