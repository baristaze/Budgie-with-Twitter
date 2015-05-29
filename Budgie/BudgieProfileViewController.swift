//
//  BudgieProfileViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieProfileViewController: UIViewController {

    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var friendsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    
    @IBOutlet var logOutButton: UIButton!
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.resetClient()
        User.currentUser?.logout()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = User.currentUser!
        nameLabel.text = currentUser.name
        screenNameLabel.text = "@" + currentUser.screenName!
        taglineLabel.text = currentUser.tagline
        locationLabel.text = currentUser.location
        friendsCountLabel.text = "\(currentUser.friendsCount!)"
        followersCountLabel.text = "\(currentUser.followersCount!)"
        bannerImageView.setImageWithURL(NSURL(string: currentUser.profileBannerUrl!)!)
        profileImageView.setImageWithURL(NSURL(string: currentUser.profileImageUrl!)!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 3
        profileImageView.clipsToBounds = true
        logOutButton.tintColor = UIColor.budgieBlue()
        

    }

}
