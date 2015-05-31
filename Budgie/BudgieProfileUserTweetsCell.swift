//
//  BudgieProfileUserTweetsCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/30/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieProfileUserTweetsCell: UICollectionViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            profileImageView.layer.cornerRadius = 5
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetTextLabel.text = tweet.text
         }
    }
}
