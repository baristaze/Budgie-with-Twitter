//
//  TweetsViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BudgieTweetCellDelegate {
    
    private let blueColor: UIColor = UIColor(red: (88.0 / 255.0), green: (145.0 / 255.0), blue: (211.0 / 255.0), alpha: 1)
    private let yellowColor: UIColor = UIColor(red: (252.0 / 255.0), green: (248.0 / 255.0), blue: (197.0 / 255.0), alpha: 1)
    private var tableViewRefreshControl: UIRefreshControl!
    private var loadingView: UIActivityIndicatorView!
    
    private let budgieTweetCellReuseIdentifier = "budgieTweetCell"
    private var tweets: [Tweet]?
    
    private var newSearch: Search!
    private var lastSearch: Search!
    private var lastSearchCount: Int!
    
    private var selectedTweet: Tweet!
    
    private var replyTweetId: String?
    private var replyUserNamed: String?
    
    struct Search {
        var limit: Int = 20
        var offset: Int = 0
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        println("BudgieHomeViewController: viewDidLoad")
        super.viewDidLoad()
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "reloadTableView", name: "shouldReloadTableViewNotification", object: nil)
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "LaunchImageTitle"))
        
//        self.tabBarController?.tabBar.barTintColor = blueColor // Tint Color to apply to the tab bar background
//        self.tabBarController?.tabBar.tintColor = yellowColor // The tint color to apply to the tab bar’s tab bar items.
//        self.tabBarController?.tabBar.translucent = false
//        self.tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
//        
//        var homeIcon = UIImage(named: "ProfileIcon_2")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        self.tabBarController!.tabBarItem.selectedImage = homeIcon
//        self.tabBarController!.tabBarItem.image = homeIcon
        
        newSearch = Search()
        lastSearch = Search()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Adds RefreshControl
        tableViewRefreshControl = UIRefreshControl()
        tableViewRefreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(tableViewRefreshControl, atIndex: 0)
        
        // Adds Activity Indicator to the footer for the infinite scrool
        var tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingView.center = tableFooterView.center
        loadingView.startAnimating()
        tableFooterView.addSubview(loadingView)
        tableView.tableFooterView = tableFooterView
        
        loadTweets(newSearch)

    }
    
    override func viewDidAppear(animated: Bool) {
        println("BudgieHomeViewController: viewDidAppear")
        super.viewDidAppear(true)
//        newSearch = lastSearch
//        loadTweets(newSearch)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func onRefresh() {
        tableView.scrollEnabled = false
        newSearch = Search()
        self.tweets = [Tweet]()
        TwitterClient.sharedInstance.resetClient()
        loadTweets(newSearch)
    }
    
    func loadTweets(params: Search!) {
        TwitterClient.sharedInstance.homeTimelineWithParams(params.offset, params: nil, completion: { (tweets, error) -> () in
            if error == nil && tweets != nil {
                if self.tweets == nil || params.offset == 0{
                    self.tweets = tweets
                } else {
                    self.tweets = self.tweets! + tweets!
                }
                println("Total Number of Tweets on memory: \(self.tweets!.count)")
                self.tableViewRefreshControl.endRefreshing()
                self.lastSearch = params
                self.lastSearchCount = self.tweets?.count
                self.tableView.reloadData()
            } else {
                println("Error loading Tweets for HomeTimeLine: \(error)")
                self.tableViewRefreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            self.tableView.scrollEnabled = true
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetToDetails" {
            let detailsVC = segue.destinationViewController as! BudgieTweetDetailsViewController
            detailsVC.tweet = selectedTweet
        } else if segue.identifier == "ReplyTweetSegue" {
            let composeTweetVC = (segue.destinationViewController as! UINavigationController).topViewController as! BudgieComposeTweetViewController
            composeTweetVC.screenName = replyUserNamed
            composeTweetVC.responseToId = replyTweetId
        }
    }


}


//MARK: UITableViewDelegate

extension BudgieHomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedTweet = tweets![indexPath.row]
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

//MARK: UITableViewDataSource

extension BudgieHomeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Getting Cell for row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier(budgieTweetCellReuseIdentifier, forIndexPath: indexPath) as! BudgieTweetCell
        cell.tweet = self.tweets![indexPath.row]
        cell.delegate = self
        if indexPath.row == (self.lastSearchCount - 1) {
            newSearch = lastSearch
            newSearch.offset += 20
            println("New offset: \(newSearch.offset)")
            loadTweets(newSearch)
        }
        return cell
    }
    
}

//MARK: BudgieTweetCellDelegate

extension BudgieHomeViewController: BudgieTweetCellDelegate {
    func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didChangeReTweetedStatus status: Bool) {
        println("didChangeReTweetedStatus")
        let indexPath = self.tableView.indexPathForCell(budgieTweetCell)!
        self.tweets![indexPath.row].isRetweeted = status
    }
    
    func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didChangeFavoriteStatus status: Bool) {
        println("didChangeFavoriteStatus")
        let indexPath = self.tableView.indexPathForCell(budgieTweetCell)!
        self.tweets![indexPath.row].isFavorited = status
    }
    
    func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didPressReplyTweetId tweetId: String, fromUserNamed: String) {
        self.replyTweetId = tweetId
        self.replyUserNamed = fromUserNamed
        self.performSegueWithIdentifier("ReplyTweetSegue", sender: self)
    }
    
    
}