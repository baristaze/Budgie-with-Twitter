//
//  TwitterClient.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/18/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

let twitterConsumerKey = "nY3QdtSgwmQl7OEBavf9CK6sz"
let twitterConsumerSecret = "W2oy2CbeBixLaAUX166tzM4aR7eYLtSLn1G0JeXpg01QzYZG1B"
let twitterBaseURL = NSURL(string: "https://api.twitter.com/")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    private var loginCompletion: ((user: User?, error: NSError?) -> ())?
    private var oldestTweetId: Double?
    private var newestTweetId: Double?
    private var oldestTweetIdString: String?
    private var newestTweetIdString: String?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> () ) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
//            println((response as! [NSDictionary])[0])
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])

            self.newestTweetId = tweets[0].tweetId
            self.newestTweetIdString = tweets[0].tweetIdString
            self.oldestTweetId = tweets[tweets.count - 1].tweetId
            self.oldestTweetIdString = tweets[tweets.count - 1].tweetIdString
            
            completion(tweets: tweets, error: nil)
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("Error Getting Current User")
            completion(tweets: nil, error: error)
        })
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            println("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
                
        }
    }
    
    func sendTweet(tweetText: String!, replyToTweetID: String?, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        
        var params: NSDictionary?
        
        if let replyToTweetID = replyToTweetID {
            params = ["status": tweetText, "in_reply_to_status_id": replyToTweetID]
        } else {
            params = ["status": tweetText]
        }
        
        POST("1.1/statuses/update.json", parameters: params!, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            println("Budgie posted your tweet with Id: \(tweet.tweetId!)")
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Budgie failed to post yor tweet")
                println(error)
                completion(tweet: nil, error: error)
        }
        
    }
    
    func retweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        
        var tweetId = tweet.tweetIdString!
        
        if !(tweet.isRetweeted!) {
            var urlString = "1.1/statuses/retweet/" + tweetId + ".json"
            POST(urlString, parameters: ["trim_user" : false], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Budgie retweeted tweet with Id: \(tweetId)")
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Budgie failed to retweet tweet with Id: \(tweetId)")
                println(error)
                completion(tweet: nil, error: error)
            }
        } else {
//            var urlString = "1.1/statuses/destroy/" + tweetId + ".json"
//            POST(urlString, parameters: ["trim_user" : false], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                println("Budgie unRetweeted tweet with Id: \(tweetId)")
//                var tweet = Tweet(dictionary: response as! NSDictionary)
//                completion(tweet: tweet, error: nil)
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println("Budgie failed to unRetweet tweet with Id: \(tweetId)")
//                println(error)
//                completion(tweet: nil, error: error)
//            }
        }
        
    }
    
    func favorite(tweetId: String!, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        
        POST("1.1/favorites/create.json", parameters: ["id":tweetId], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Budgie favorited tweet with Id: \(tweetId)")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Budgie failed to favorite tweet with Id: \(tweetId)")
                println(error)
                completion(tweet: nil, error: error)
        }
        
    }
    
    func openURL(url: NSURL) {
//        if url.scheme! == "cptwitterdemo" {
//            if url.host! == "oauth" {
//                var parameters: NSDictionary = NSDictionary.bdb_dictionaryFromQueryString(url.absoluteString!)
//                let oauthToken: String? = parameters["cptwitterdemo://oauth?oauth_token"] as? String
//                let oauthVerifier: String? = parameters["oauth_verifier"] as? String
//                if oauthToken != nil && oauthVerifier != nil {
                    TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                        
                        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                            var user = User(dictionary: response as! NSDictionary)
                            println("######################################################################################################")
                            println(response)
                            println("######################################################################################################")
                            User.currentUser = user
//                            println(user.name!)
//                            println(user.screenName!)
//                            println(user.profileImageUrl!)
//                            println(user.tagline!)
                            self.loginCompletion?(user: user, error: nil)
                            
                        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            println("Error Getting Current User")
                            self.loginCompletion?(user: nil, error: error)
                        })

                    }, failure: { (error:NSError!) -> Void in
                        println("Failed to get accessToken")
                        self.loginCompletion?(user: nil, error: error)
                    })
//                } else { self.loginCompletion?(user: nil, error: nil) }
//            } else { self.loginCompletion?(user: nil, error: nil) }
//        } else { self.loginCompletion?(user: nil, error: nil) }
    }

}
