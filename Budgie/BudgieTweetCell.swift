//
//  BudgieTweetCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

@objc protocol BudgieTweetCellDelegate {
    optional func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didChangeFavoriteStatus status: Bool)
    optional func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didChangeReTweetedStatus status: Bool)
    optional func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didPressReplyTweetId tweetId: String, fromUserNamed: String)
    optional func budgieTweetCell(budgieTweetCell: BudgieTweetCell, didTapOnImageForUser user: User)
}

class BudgieTweetCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    @IBOutlet var retweetedFromLabel: UILabel!
    @IBOutlet var retweetedIcon: UIImageView!
    
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    weak var delegate: BudgieTweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            profileImageView.userInteractionEnabled = true
            var tapRecognizer = UITapGestureRecognizer(target: self, action: "onProfileImageTapped")
            profileImageView.addGestureRecognizer(tapRecognizer)
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetTextLabel.text = tweet.text
            createdAtLabel.text = tweet.dateToDisplay
            retweetCountLabel.text = "\(tweet.retweetCount!)"
            favoriteCountLabel.text = "\(tweet.favoriteCount!)"
            if tweet.isRetweeted! { self.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal) }
            else { self.retweetButton.setImage(UIImage(named: "retweet.png"), forState: .Normal) }
            if tweet.isFavorited! { self.favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: .Normal) }
            else { self.favoriteButton.setImage(UIImage(named: "favorite.png"), forState: .Normal) }
            
            var range = tweet.text!.rangeOfString("RT")
            if (range != nil) && (range?.startIndex == tweet.text!.startIndex)  {
                retweetedIcon.hidden = false
                var range2 = tweet.text!.rangeOfString(":")
                retweetedFromLabel.text = "Retweeted from " + tweet.text!.substringToIndex(range2!.startIndex).substringFromIndex(range!.endIndex)
            } else {
                retweetedIcon.hidden = true
                retweetedFromLabel.text = ""
            }
        }
        
    }
    
    func onProfileImageTapped() {
        self.delegate?.budgieTweetCell!(self, didTapOnImageForUser: tweet.user!)
    }
   
    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.budgieTweetCell!(self, didPressReplyTweetId: tweet.tweetIdString!, fromUserNamed: tweet.user!.screenName!)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet, completion: { (success, tweet, error) -> () in
            if error == nil {
                println("The cell knows that the tweet has been retweeted")
                self.retweetCountLabel.text = "\(self.tweet.retweetCount! + 1)"
                self.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
                (self.delegate?.budgieTweetCell!(self, didChangeReTweetedStatus:  !(self.tweet.isRetweeted!)))
            } else {
                println(("The cell knows there has been an error retweeting"))
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet.tweetIdString!, completion: { (success, tweet, error) -> () in
            if error == nil {
                println("The cell knows that the tweet has been favorited")
                self.favoriteCountLabel.text = "\(self.tweet.favoriteCount! + 1)"
                self.favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: .Normal)
                (self.delegate?.budgieTweetCell!(self, didChangeFavoriteStatus:  !(self.tweet.isFavorited!)))
            } else {
                println(("The cell knows there has been an error favoriting"))
            }
        })
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layoutIfNeeded()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
