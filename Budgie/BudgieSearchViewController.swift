//
//  BudgieSearchViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/30/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BudgieTweetCellDelegate, BudgieComposeTweetViewControllerDelegate, UISearchBarDelegate {
    
    private var loadingView: UIActivityIndicatorView!
    
    private let budgieTweetCellReuseIdentifier = "budgieTweetCell"
    private var tweets: [Tweet]?
    private var users: [User]?
    
    private var selectedTweet: Tweet!
    
    private var replyTweetId: String?
    private var replyUserNamed: String?
    
    private var isInitialLoad: Bool!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        println("BudgieHomeViewController: viewDidLoad")
        super.viewDidLoad()
        
        searchBar.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "searchTweetsOrUsers", forControlEvents: UIControlEvents.ValueChanged)
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "reloadTableView", name: "shouldReloadTableViewNotification", object: nil)
        
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.budgieBlue()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "SearchTitle"))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        isInitialLoad = true
        tweets = nil
        users = nil
        
        tableView.reloadData()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("BudgieHomeViewController: viewDidAppear")
        super.viewDidAppear(true)
        userForProfile = nil
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
    }
    
    
    func searchTweetsOrUsers() {
        if self.searchBar.text != nil && self.searchBar.text != "" {
            searchBar.resignFirstResponder()
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.Indeterminate, animated: true)
        
            if segmentedControl.selectedSegmentIndex == 0 {
                TwitterClient.sharedInstance.searchTweetsWithQuery(self.searchBar.text, params: nil, completion: { (success, tweets, error) -> () in
                    if success {
                        self.tweets = tweets
                        self.tableView.reloadData()
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    } else {
                        println(error)
                        self.tableView.reloadData()
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    }
                })
            } else {
                TwitterClient.sharedInstance.searchUsersWithQuery(self.searchBar.text, params: nil, completion: { (success, users, error) -> () in
                    if success {
                        self.users = users
                        self.tableView.reloadData()
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    } else {
                        println(error)
                        self.tableView.reloadData()
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    }
                })
            }
        }
    }
    
    
    func reloadTableView() {
        self.tableView.reloadData()
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
        } else if segue.identifier == "ComposeNewTweetSegue" {
            let composeTweetVC = (segue.destinationViewController as! UINavigationController).topViewController as! BudgieComposeTweetViewController
            composeTweetVC.delegate = self
        }
    }
    
    
}


//MARK: UITableViewDelegate

extension BudgieSearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if tweets != nil {
            selectedTweet = tweets![indexPath.row]
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

//MARK: UITableViewDataSource

extension BudgieSearchViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return tweets?.count ?? 0
        } else {
            return users?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Getting Cell for row: \(indexPath.row)")
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchTweetCell", forIndexPath: indexPath) as! BudgieTweetCell
            cell.tweet = self.tweets![indexPath.row]
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchUserCell", forIndexPath: indexPath) as! BudgieSearchUserCell
            cell.user = self.users![indexPath.row]
            return cell
        }
    }
    
}

//MARK: BudgieTweetCellDelegate

extension BudgieSearchViewController: BudgieTweetCellDelegate {
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
    
    func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didTapOnImageForUser user: User) {
        println("Tapped on User: \(user.name)")
        userForProfile = user
        self.tabBarController?.selectedIndex = 3
    }
    
}

//MARK: BudgieComposeTweetViewControllerDelegate

extension BudgieSearchViewController: BudgieComposeTweetViewControllerDelegate {
    func budgieComposeTweetViewController(budgieComposeTweetViewController: BudgieComposeTweetViewController, didPostNewTweet tweet: Tweet) {
        self.tweets = [tweet] + self.tweets!
        self.tableView.reloadData()
    }
}

//MARK: UISearchBarDelegate
extension BudgieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Buscar")
        searchTweetsOrUsers()
    }
}