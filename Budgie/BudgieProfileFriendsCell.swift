//
//  BudgieProfileFriendsCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/30/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieProfileFriendsCell: UICollectionViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var friend: User! {
        didSet{
            nameLabel.text = friend.name
            profileImageView.setImageWithURL(NSURL(string: friend.profileImageUrl!))
            profileImageView.layer.cornerRadius = 24
            profileImageView.clipsToBounds = true
        }
    }
}
