//
//  User.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/18/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

var _currentUser: User?
var currentUserKey = "kCurrentUserKey"
var userDidLoginNotification = "userDidLoginNotification"
var userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileBannerUrl: String?
    var tagline: String?
    var friendsCount: Int?
    var followersCount: Int?
    var location: String?
    
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        if let banner = (dictionary["profile_banner_url"] as? String) {
            profileBannerUrl = (dictionary["profile_banner_url"] as? String)! + "/600x200" // Other Options: 1500x500 / 600x200 / 300x100 / and more based on Device
        } else {
            profileBannerUrl = "https://pbs.twimg.com/profile_banners/36671170/1357326210/600x200"
        }
        tagline = dictionary["description"] as? String
        friendsCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        location = dictionary["location"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary
                    _currentUser = User(dictionary: dictionary!)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
