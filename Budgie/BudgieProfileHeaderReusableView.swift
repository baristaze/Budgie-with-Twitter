//
//  BudgieProfileHeaderReusableView.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/28/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

@objc protocol BudgieProfileHeaderReusableViewDelegate {
    optional func budgieProfileHeaderReusableView(budgieProfileHeaderReusableView: BudgieProfileHeaderReusableView, segmentedControl: UISegmentedControl, didChangeSelectedIndex index: Int)
    
}

class BudgieProfileHeaderReusableView: UICollectionReusableView, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var firstView: UIView!
//    @IBOutlet var secondView: UIView!
    
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var friendsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    
//    @IBOutlet var taglineLabel: UILabel!
    
    var taglineText: String!
    
    weak var delegate: BudgieProfileHeaderReusableViewDelegate?
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    private var views: [UIView]!
    
    var user: User! {
        didSet{
            nameLabel.text = user.name
            screenNameLabel.text = "@" + user.screenName!
            taglineText = user.tagline
            locationLabel.text = user.location
            friendsCountLabel.text = "\(user.friendsCount!)"
            followersCountLabel.text = "\(user.followersCount!)"
            bannerImageView.setImageWithURL(NSURL(string: user.profileBannerUrl!)!)
            bannerImageView.backgroundColor = UIColor.clearColor()
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
            profileImageView.layer.borderWidth = 3
            profileImageView.clipsToBounds = true
            
        }
    }
    
    
    var scrollFrameWidth: CGFloat! {
        didSet{
            scrollView.delegate = self
            scrollView.backgroundColor = UIColor.whiteColor()
            scrollView.frame = CGRect(origin: scrollView.frame.origin, size: CGSize(width: scrollFrameWidth, height: scrollView.frame.height))
            scrollView.pagingEnabled = true
            scrollView.contentSize = CGSize(width: 2 * scrollView.frame.width, height: scrollView.frame.height)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            
            firstView.frame = scrollView.frame
            var secondView = UILabel(frame: scrollView.frame)
            secondView.frame.origin = CGPoint(x: scrollView.frame.width, y: 10)
            secondView.text = taglineText
            secondView.textAlignment = NSTextAlignment.Center
            secondView.lineBreakMode = .ByWordWrapping
            secondView.numberOfLines = 0
            
            firstView.backgroundColor = UIColor.whiteColor()
            secondView.backgroundColor = UIColor.whiteColor()
            
            scrollView.addSubview(secondView)
            
            pageControl.numberOfPages = 2
            pageControl.currentPage = 0
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.addTarget(self, action: "onSegmentedControlAction:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func onSegmentedControlAction(sender: UISegmentedControl) {
        delegate?.budgieProfileHeaderReusableView!(self, segmentedControl: sender, didChangeSelectedIndex: sender.selectedSegmentIndex)
    }

}

extension BudgieProfileHeaderReusableView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("Scrolling")
        var pageIndex = floor(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
}


