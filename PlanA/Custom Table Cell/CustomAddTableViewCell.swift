//
//  CustomAddTableViewCell.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/14/23.
//

import UIKit

class CustomAddTableViewCell: UITableViewCell {

    @IBOutlet var addButton: UIButton!
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
