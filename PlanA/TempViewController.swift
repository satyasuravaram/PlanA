//
//  TempViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 4/6/23.
//

import UIKit

class TempViewController: UIViewController {

    @IBOutlet var dropDown: DropDown!
    
    var items = ["test", "byeee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dropDown.isSearchEnable = true
        dropDown.optionArray = items
    }
    
    @IBAction func textChanged() {
        if(dropDown.searchText != "") {
            dropDown.dataArray = self.items.filter({ word -> Bool in
                word.lowercased().contains(dropDown.searchText.lowercased())
            })
            dropDown.reloadAll()
        } else {
            dropDown.dataArray = self.items
            dropDown.reloadAll()
        }
    }

}
