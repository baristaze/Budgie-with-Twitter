//
//  BudgieMenuProfileCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/30/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieMenuProfileCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
