//
//  BudgieTweetDetailsViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieTweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BudgieDetailsActionsCellDelegate {
    
    var tweet: Tweet! {
        didSet {
            self.replyTweetId = tweet.tweetIdString
            self.replyUserNamed = tweet.user?.screenName
        }
    }
    private let yellowColor: UIColor = UIColor(red: (252.0 / 255.0), green: (248.0 / 255.0), blue: (197.0 / 255.0), alpha: 1)
    private var replyTweetId: String?
    private var replyUserNamed: String?
    private let budgieDetailHeaderCellReuseIdentifier = "budgieDetailHeaderCell"
    private let budgieDetailsCountersCellReuseIdentifier = "budgieDetailsCountersCell"
    private let budgieDetailsActionsCellReuseIdentifier = "budgieDetailsActionsCell"
    private let budgieDetailsEmptyCellReuseIdentifier = "budgieDetailsEmptyCell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.backgroundColor = yellowColor.colorWithAlphaComponent(0.5)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailReplyTweetSegue" {
            let composeTweetVC = (segue.destinationViewController as! UINavigationController).topViewController as! BudgieComposeTweetViewController
            composeTweetVC.screenName = replyUserNamed
            composeTweetVC.responseToId = replyTweetId
        }
    }


}

//MARK: UITableViewDelegate

extension BudgieTweetDetailsViewController: UITableViewDelegate {
    
}

//MARK: UITableViewDataSource

extension BudgieTweetDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorColor = UIColor.clearColor()
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailHeaderCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsHeaderCell
            cell.tweet = self.tweet
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailsActionsCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsActionsCell
            cell.tweet = self.tweet
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailsEmptyCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsEmptyCell
            cell.tweet = self.tweet
            return cell
        }
    }
    
}

//MARK: BudgieTweetCellDelegate

extension BudgieTweetDetailsViewController: BudgieDetailsActionsCellDelegate {
    func budgieDetailsActionsCell(budgieDetailsActionsCell: BudgieDetailsActionsCell, didChangeReTweetedStatus status: Bool) {
        self.tweet.isRetweeted = status
    }
    
    func budgieDetailsActionsCell(budgieDetailsActionsCell: BudgieDetailsActionsCell, didChangeFavoriteStatus status: Bool) {
        self.tweet.isFavorited = status
    }
    
    func budgieDetailsActionsCell(budgieDetailsActionsCell: BudgieDetailsActionsCell, didPressReplyTweetId tweetId: String, fromUserNamed: String) {
        self.replyTweetId = tweetId
        self.replyUserNamed = fromUserNamed
        self.performSegueWithIdentifier("DetailReplyTweetSegue", sender: self)
    }

    
}