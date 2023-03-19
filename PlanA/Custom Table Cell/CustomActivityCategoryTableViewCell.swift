//
//  CustomActivityCategoryTableViewCell.swift
//  PlanA
//
//  Created by Satya Suravaram on 3/17/23.
//

import UIKit

class CustomActivityCategoryTableViewCell: UITableViewCell {

  
    @IBOutlet weak var cellBackground: UIImageView!
    @IBOutlet weak var headerBackground: UIStackView!
    @IBOutlet weak var activityNumber: UILabel!
    @IBOutlet weak var selectActivity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
