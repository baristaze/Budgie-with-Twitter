//
//  BudgieSearchUserCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/30/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieSearchUserCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var user: User! {
        didSet{
            nameLabel.text = user.name
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            profileImageView.layer.cornerRadius = 24
            profileImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
