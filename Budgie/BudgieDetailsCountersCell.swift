//
//  BudgieDetailsCountersCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieDetailsCountersCell: UITableViewCell {

        @IBOutlet var retweetCountLabel: UILabel!
        @IBOutlet var favoriteCountLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            retweetCountLabel.text = "\(tweet.retweetCount!)"
            favoriteCountLabel.text = "\(tweet.favoriteCount!)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
