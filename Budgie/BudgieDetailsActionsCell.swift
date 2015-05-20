//
//  BudgieDetailsActionsCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

@objc protocol BudgieDetailsActionsCellDelegate {
    optional func budgieDetailsActionsCell(budgieDetailsActionsCell: BudgieDetailsActionsCell, didChangeFavoriteStatus status: Bool)
    optional func budgieDetailsActionsCell(budgieDetailsActionsCell: BudgieDetailsActionsCell, didChangeReTweetedStatus status: Bool)
    optional func budgieDetailsActionsCell(budgieDetailsActionsCell: BudgieDetailsActionsCell, didPressReplyTweetId tweetId: String, fromUserNamed: String)
}

class BudgieDetailsActionsCell: UITableViewCell {
    
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    weak var delegate: BudgieDetailsActionsCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            retweetCountLabel.text = "\(tweet.retweetCount!)"
            favoriteCountLabel.text = "\(tweet.favoriteCount!)"
            if tweet.isRetweeted! { self.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal) }
            else { self.retweetButton.setImage(UIImage(named: "retweet.png"), forState: .Normal) }
            if tweet.isFavorited! { self.favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: .Normal) }
            else { self.favoriteButton.setImage(UIImage(named: "favorite.png"), forState: .Normal) }
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.budgieDetailsActionsCell!(self, didPressReplyTweetId: tweet.tweetIdString!, fromUserNamed: tweet.user!.screenName!)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet, completion: { (tweet, error) -> () in
            if error == nil {
                println("The cell knows that the tweet has been retweeted")
                self.retweetCountLabel.text = "\(self.tweet.retweetCount! + 1)"
                self.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
                (self.delegate?.budgieDetailsActionsCell!(self, didChangeReTweetedStatus:  !(self.tweet.isRetweeted!)))
            } else {
                println(("The cell knows there has been an error retweeting"))
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet.tweetIdString!, completion: { (tweet, error) -> () in
            if error == nil {
                println("The cell knows that the tweet has been favorited")
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount! + 1)"
                self.favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: .Normal)
                (self.delegate?.budgieDetailsActionsCell!(self, didChangeFavoriteStatus:  !(self.tweet.isFavorited!)))
            } else {
                println(("The cell knows there has been an error favoriting"))
            }
        })
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
