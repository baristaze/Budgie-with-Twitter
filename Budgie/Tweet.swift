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
    var createdAtString: String?
    var createdAt: NSDate?
    var dateToDisplay: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var isRetweeted: Bool?
    var isFavorited: Bool?
    var mediaURL: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text  = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        tweetId = dictionary["id"] as? Double
        tweetIdString = dictionary["id_str"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        createdAt = formatter.dateFromString(createdAtString!)
        var intervalSinceCreated = NSDate().timeIntervalSinceDate(createdAt!)
        var hh: Int = Int(intervalSinceCreated / 3600.0)
        var mm: Int = Int(intervalSinceCreated / 60.0)
        var ss = Int(intervalSinceCreated - Double(hh * 3600) - Double(mm * 60))
        
        if hh >= 24 {
            formatter.dateFormat = "MM/dd/yy"
            dateToDisplay = formatter.stringFromDate(createdAt!)
        } else if hh >= 1 {
            dateToDisplay = "\(hh)h"
        } else if mm > 0 {
            dateToDisplay = "\(mm)m"
        } else {
            dateToDisplay = "\(ss)s"
        }
        
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        isRetweeted = dictionary["retweeted"] as? Bool
        isFavorited = dictionary["favorited"] as? Bool
        
    }
    
    private func calcDisplayDate(createdAt: NSDate?) {
        
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
   
}
