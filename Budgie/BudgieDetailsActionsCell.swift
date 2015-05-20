//
//  BudgieDetailsActionsCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieDetailsActionsCell: UITableViewCell {
    
    var tweet: Tweet! {
        didSet {

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        
    }
    
    override func layoutSubviews() {
        println("BudgieTweetCell: layoutSubviews")
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
