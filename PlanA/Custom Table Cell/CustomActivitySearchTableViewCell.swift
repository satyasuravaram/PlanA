//
//  CustomActivitySearchTableViewCell.swift
//  PlanA
//
//  Created by Satya Suravaram on 3/21/23.
//

import UIKit

class CustomActivitySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var leftCategory: UIImageView!
    @IBOutlet weak var leftCategoryLabel: UILabel!
    @IBOutlet weak var rightCategory: UIImageView!
    @IBOutlet weak var rightCategoryLabel: UILabel!
    @IBOutlet weak var leftVStack: UIStackView!
    @IBOutlet weak var rightVStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
