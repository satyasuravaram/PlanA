//
//  CustomAddActivityBoxTableViewCell.swift
//  PlanA
//
//  Created by Satya Suravaram on 3/17/23.
//

import UIKit

class CustomAddActivityBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var addActivityBoxButton: UIButton!
    var insertBox: ((Int) -> ())?
    var index:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        insertBox?(index)
    }
}
