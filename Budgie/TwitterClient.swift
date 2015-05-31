//
//  TwitterClient.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/18/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

let twitterConsumerKey = plistContent?.valueForKey("TWITTER_CONSUMER_KEY") as! String //"nY3QdtSgwmQl7OEBavf9CK6sz"
let twitterConsumerSecret = plistContent?.valueForKey("TWITTER_CONSUMER_SECRET") as! String //"W2oy2CbeBixLaAUX166tzM4aR7eYLtSLn1G0JeXpg01QzYZG1B"
let twitterBaseURL = NSURL(string: plistContent?.valueForKey("TWITTER_BASE_URL") as! String) // "https://api.twitter.com/")
let accessTokenPath = plistContent?.valueForKey("OAUTH_ACCESS_TOKEN_PATH") as! String
let requestTokenPath = plistContent?.valueForKey("OAUTH_REQUEST_TOKEN_PATH") as! String
let authenticateReqTokenPath = plistContent?.valueForKey("OAUTH_AUTHENTICATE_REQ_TOKEN_PATH") as! String
let rateLimitStatusPath = plistContent?.valueForKey("RATE_LIMIT_STATUS") as! String
let timeLinePath = plistContent?.valueForKey("HOME_TIMELINE_PATH") as! String
let postTweetPath = plistContent?.valueForKey("UPDATE_STATUS_PATH") as! String
let retweetPath = plistContent?.valueForKey("RETWEET_PATH") as! String
let favoriteTweetPath = plistContent?.valueForKey("CREATE_FAVORITE_PATH") as! String
let verifyCredentialsPath = plistContent?.valueForKey("VERIFY_CREDENTIALS_PATH") as! String
let mentionsPath = plistContent?.valueForKey("MENTIONS_PATH") as! String
let userTimeLinePath = plistContent?.valueForKey("USER_TIMELINE_PATH") as! String
let friendsListPath = plistContent?.valueForKey("FRIENDS_LIST_PATH") as! String
let searchTweetsPath = plistContent?.valueForKey("SEARCH_TWEETS_PATH") as! String
let searchUsersPath = plistContent?.valueForKey("SEARCH_USERS_PATH") as! String

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    private var loginCompletion: BudgieUserResponse?
    private var oldestTweetId: Double?
    private var newestTweetId: Double?
    private var oldestTweetIdString: String?
    private var newestTweetIdString: String?
    private var tweetsCache: [NSDictionary]?
    private var currentOffset: Int?
    private var lastCallDidReturn: Bool = true
    
    typealias BudgieHomeTimeLineResponse = (success: Bool, tweets: [Tweet]?, error: NSError?) -> ()
    typealias BudgieSearchTweetsResponse = (success: Bool, tweets: [Tweet]?, error: NSError?) -> ()
    typealias BudgieSearchUsersResponse = (success: Bool, users: [User]?, error: NSError?) -> ()
    typealias BudgieTweetResponse = (success: Bool, tweet: Tweet?, error: NSError?) -> ()
    typealias BudgieUserResponse = (success: Bool, user: User?, error: NSError?) -> ()
    typealias BudgieFriendsResponse = (success: Bool, friends: [User]?, error: NSError?) -> ()
    typealias BudgieMediaResponse = (success: Bool, media: [String]?, error: NSError?) -> ()
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func searchTweetsWithQuery(query: String?, params: NSDictionary?, completion: BudgieSearchTweetsResponse) {
        if query != nil {
            var formattedQuery = parseQuery(query!)
            GET(searchTweetsPath, parameters: ["q":formattedQuery, "count":100], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                var result = (response as! NSDictionary)["statuses"] as! [NSDictionary]
                var tweetsReceived = Tweet.tweetsWithArray(result)
                completion(success: true, tweets: tweetsReceived, error: nil)
            }) { (response:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(success: false, tweets: nil, error: error)
            }
            
        } else {
            completion(success: true, tweets: nil, error: nil)
        }
    }
    
    func searchUsersWithQuery(query: String?, params: NSDictionary?, completion: BudgieSearchUsersResponse) {
        if query != nil {
            var formattedQuery = parseQuery(query!)
            GET(searchUsersPath, parameters: ["q":formattedQuery, "count":20], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                var result = User.usersWithArray(response as! [NSDictionary])
                completion(success: true, users: result, error: nil)
            }) { (response:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(success: false, users: nil, error: error)
            }
            
        } else {
            completion(success: true, users: nil, error: nil)
        }
    }
    
    func parseQuery(query: String) -> String {
        
        var newQuery = query.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        newQuery = newQuery.stringByReplacingOccurrencesOfString("#", withString: "%23", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        newQuery = newQuery.stringByReplacingOccurrencesOfString("@", withString: "%40", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        newQuery = newQuery.stringByReplacingOccurrencesOfString("\"", withString: "%22", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        println(newQuery)
        return newQuery
    }
    
    func friendsList(params: NSDictionary?, completion: BudgieFriendsResponse) {
        var user = (params!["screen_name"] as? String != nil) ? params!["screen_name"] as? String : User.currentUser!.screenName
        GET(friendsListPath, parameters: ["screen_name":user!, "count":200], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var friendsRaw = (response as! NSDictionary)["users"] as! [NSDictionary]
            var friends = User.usersWithArray(friendsRaw)
            completion(success: true, friends: friends, error: nil)
        }) { (response:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(success: false, friends: nil, error: error)
        }
        
    }
    
    func mentionsTimeLine(params: NSDictionary?, completion: BudgieHomeTimeLineResponse) {
        GET(mentionsPath, parameters: ["count":200], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var mentions = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(success: true, tweets: mentions, error: nil)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(success: false, tweets: nil, error: error)
        }
    }
    
    func userMedia(params: NSDictionary?, completion: BudgieMediaResponse) {
        var user = (params!["screen_name"] as? String != nil) ? params!["screen_name"] as? String : User.currentUser!.screenName
        GET(userTimeLinePath, parameters: ["screen_name":user!, "count":200], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            
            var mediaUrlArray = [String]()
            for item in (response as! [NSDictionary]) {
                var mediaUrl = item.valueForKeyPath("entities.media.media_url") as? [String]
                if mediaUrl != nil {
                    mediaUrlArray.append(mediaUrl![0])
                }
            }
            completion(success: true, media: mediaUrlArray, error: nil)
            
        }) { (response:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(success: false, media: nil, error: error)
        }
    }
    
    func userTimeLine(params: NSDictionary?, completion: BudgieHomeTimeLineResponse) {
        var user = (params!["screen_name"] as? String != nil) ? params!["screen_name"] as? String : User.currentUser!.screenName
        GET(userTimeLinePath, parameters: ["screen_name":user!, "count":200], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var timeLine = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(success: true, tweets: timeLine, error: nil)
        }) { (response:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(success: false, tweets: nil, error: error)
        }
    }
    
    
    func demoTweets() -> ([Tweet]?) {
        
        var jsonData = NSUserDefaults.standardUserDefaults().dataForKey("demoTweets")
        if jsonData != nil {
            var tweetsDic = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [NSDictionary]
            var tweets = Tweet.tweetsWithArray(tweetsDic)
            return tweets
        }
        return nil
    }
    
    
    func cachedHomeTimeLineWithParams(offset: Int?, params: NSDictionary?, completion: BudgieHomeTimeLineResponse) {
        
        currentOffset = offset ?? 0
        
        if (tweetsCache != nil) && (tweetsCache!.count != 0) && (currentOffset! <= (tweetsCache!.count - 20)) {
            println("Returning chached Tweets")
            var upperLimit = (self.currentOffset! + 20) < (self.tweetsCache!.count) ? (self.currentOffset! + 20) : (self.tweetsCache!.count)
            var cachedTweets = Tweet.tweetsWithArray(Array(self.tweetsCache![self.currentOffset!..<upperLimit]))
            self.newestTweetId = cachedTweets[0].tweetId
            self.newestTweetIdString = cachedTweets[0].tweetIdString
            self.oldestTweetId = cachedTweets[cachedTweets.count - 1].tweetId
            self.oldestTweetIdString = cachedTweets[cachedTweets.count - 1].tweetIdString
            completion(success: true, tweets: cachedTweets, error: nil)
        } else if lastCallDidReturn {
            println("Calling the API for more Tweets")
            lastCallDidReturn = false
            GET(timeLinePath , parameters: ["count":200], success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                
                if self.tweetsCache == nil {
                    self.tweetsCache = response as? [NSDictionary]
                } else {
                    self.tweetsCache! += (response as! [NSDictionary])
                }
//////////////////
                var demoData = NSJSONSerialization.dataWithJSONObject(response, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(demoData, forKey: "demoTweets")
/////////////////
                println("TweetCache Updated. New Count: \(self.tweetsCache!.count)")
                var upperLimit = (self.currentOffset! + 20) < (self.tweetsCache!.count) ? (self.currentOffset! + 20) : (self.tweetsCache!.count)
                
                var tweets = Tweet.tweetsWithArray(Array(self.tweetsCache![self.currentOffset!..<upperLimit]))
                println("Returning >>  \(tweets.count) << tweets")
                self.newestTweetId = tweets[0].tweetId
                self.newestTweetIdString = tweets[0].tweetIdString
                self.oldestTweetId = tweets[tweets.count - 1].tweetId
                self.oldestTweetIdString = tweets[tweets.count - 1].tweetIdString
                self.lastCallDidReturn = true
                completion(success: true, tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("Error Getting Current User")
                self.lastCallDidReturn = true
                completion(success: false, tweets: nil, error: error)
            })
            
        } else {
            println("Previous call to API still pending. Ignoring request")
            completion(success: false, tweets: nil, error: NSError(domain: "twitterAPI", code: 1, userInfo: nil)) // Code 1: Previous call still pendint
        }
        
    }

    

    func homeTimelineWithParams(offset: Int?, params: NSDictionary?, completion: BudgieHomeTimeLineResponse ) {
        cachedHomeTimeLineWithParams(offset, params: params) { (success, tweets, error) -> () in
            if error == nil {
                completion(success: true, tweets: tweets, error: nil)
            } else {
                completion(success: false, tweets: nil, error: error)
            }
        }
    }
    

    func loginWithCompletion(completion: BudgieUserResponse) {
        loginCompletion = completion

        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath(requestTokenPath, method: "POST", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            var authURL = NSURL(string: twitterBaseURL!.absoluteString! + authenticateReqTokenPath + "\(requestToken.token)" )
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            println("Failed to get request token")
            self.loginCompletion?(success: false, user: nil, error: error)
        }
    }
    
    func resetClient() {
        oldestTweetId = nil
        oldestTweetIdString = nil
        newestTweetId = nil
        newestTweetIdString = nil
        tweetsCache = [NSDictionary]()
        currentOffset = nil
    }
    
    func sendTweet(tweetText: String!, replyToTweetID: String?, completion: BudgieTweetResponse ) {
        
        var params: NSDictionary?
        
        if let replyToTweetID = replyToTweetID {
            params = ["status": tweetText, "in_reply_to_status_id": replyToTweetID]
        } else {
            params = ["status": tweetText]
        }
        
        POST(postTweetPath, parameters: params!, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            println("Budgie posted your tweet with Id: \(tweet.tweetId!)")
            completion(success: true, tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Budgie failed to post yor tweet")
                println(error)
                completion(success: false, tweet: nil, error: error)
        }
        
    }
    
    func retweet(tweet: Tweet, completion: BudgieTweetResponse ) {
        
        var tweetId = tweet.tweetIdString!
        
        if !(tweet.isRetweeted!) {
            var urlString = retweetPath + tweetId + ".json"
            POST(urlString, parameters: ["trim_user" : false], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Budgie retweeted tweet with Id: \(tweetId)")
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(success: true, tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Budgie failed to retweet tweet with Id: \(tweetId)")
                println(error)
                completion(success: false, tweet: nil, error: error)
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
    
    func favorite(tweetId: String!, completion: BudgieTweetResponse ) {
        
        POST(favoriteTweetPath, parameters: ["id":tweetId], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Budgie favorited tweet with Id: \(tweetId)")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(success: true, tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Budgie failed to favorite tweet with Id: \(tweetId)")
                println(error)
                completion(success: false, tweet: nil, error: error)
        }
        
    }
    
    func openURL(url: NSURL) {
//        if url.scheme! == "cptwitterdemo" {
//            if url.host! == "oauth" {
//                var parameters: NSDictionary = NSDictionary.bdb_dictionaryFromQueryString(url.absoluteString!)
//                let oauthToken: String? = parameters["cptwitterdemo://oauth?oauth_token"] as? String
//                let oauthVerifier: String? = parameters["oauth_verifier"] as? String
//                if oauthToken != nil && oauthVerifier != nil {
                    TwitterClient.sharedInstance.fetchAccessTokenWithPath(accessTokenPath, method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                        
                        TwitterClient.sharedInstance.GET(verifyCredentialsPath, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                            var user = User(dictionary: response as! NSDictionary)
                            println("######################################################################################################")
                            println(response)
                            println("######################################################################################################")
                            User.currentUser = user
//                            println(user.name!)
//                            println(user.screenName!)
//                            println(user.profileImageUrl!)
//                            println(user.tagline!)
                            self.loginCompletion?(success: true, user: user, error: nil)
                            
                        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            println("Error Getting Current User")
                            self.loginCompletion?(success: false, user: nil, error: error)
                        })

                    }, failure: { (error:NSError!) -> Void in
                        println("Failed to get accessToken")
                        self.loginCompletion?(success: false, user: nil, error: error)
                    })
//                } else { self.loginCompletion?(user: nil, error: nil) }
//            } else { self.loginCompletion?(user: nil, error: nil) }
//        } else { self.loginCompletion?(user: nil, error: nil) }
    }
    
    func requestRateLimitStatus(completion: (success: Bool) -> ()) {
        GET(rateLimitStatusPath, parameters: ["resources": "statuses,account,favorites"], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println(response)
            completion(success: true)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println(error)
            completion(success: false)
        }
    }

}
