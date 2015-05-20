//
//  Tweet.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/18/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var tweetId: Double?
    var tweetIdString: String?
    var text: String?
    var createAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoriteCount: Int?
    var isRetweeted: Bool?
    var isFavorited: Bool?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text  = dictionary["text"] as? String
        createAtString = dictionary["created_at"] as? String
        tweetId = dictionary["id"] as? Double
        tweetIdString = dictionary["id_str"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z YYYY"
        createdAt = formatter.dateFromString(createAtString!)
        
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        isRetweeted = dictionary["retweeted"] as? Bool
        isFavorited = dictionary["favorited"] as? Bool
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
   
}
