//
//  BudgieSwitchAccountsCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/31/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieSwitchAccountsCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var blurEffectView: UIVisualEffectView!
    
    var user: User! {
        didSet {
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
            var bannerImageView = UIImageView(frame: self.frame)
            bannerImageView.setImageWithURL(NSURL(string: user.profileBannerUrl!)!)
            self.backgroundView = bannerImageView
        }
    }
    
    var addUserImage: UIImage! {
        didSet {
            profileImageView.image = addUserImage
            self.backgroundColor = UIColor.budgieBlue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 2
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        self.blurEffectView.alpha = 0.5
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.blurEffectView.alpha = 0.5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.blurEffectView.alpha = 0.5
        // Configure the view for the selected state
    }

}
