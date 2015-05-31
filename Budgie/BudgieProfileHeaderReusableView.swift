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
    
    @IBOutlet var blurEffectView: UIVisualEffectView!
    
    private var scale: CGFloat = 1.0
    
    private var views: [UIView]!
    
    var parentCollectionView: UICollectionView! {
        didSet {
            parentCollectionView.panGestureRecognizer.addTarget(self, action: "onPanGestureRecognizer:")
            scale = 1.0
        }
    }
    
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
        scrollView.panGestureRecognizer.addTarget(self, action: "onScrollViewPanGesture:")
        blurEffectView.alpha = 0.0

    }
    
    func onSegmentedControlAction(sender: UISegmentedControl) {
        delegate?.budgieProfileHeaderReusableView!(self, segmentedControl: sender, didChangeSelectedIndex: sender.selectedSegmentIndex)
    }
    
    
    func onScrollViewPanGesture(sender: UIPanGestureRecognizer) {
        var alphaIncrement: CGFloat = 0.02
        var velocity = sender.velocityInView(self)
        var translation = sender.translationInView(self)
        var location = sender.locationInView(self)
        
        if sender.state == UIGestureRecognizerState.Began {
            self.scrollView.alpha = 1.0
        } else if sender.state == UIGestureRecognizerState.Changed {
            println("Velocity: \(velocity)   Transalation: \(translation)")
            if translation.x != 0  && scrollView.alpha > 0.2 {
                self.scrollView.alpha -= alphaIncrement
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.scrollView.alpha = 1.0
            })
            
        }
    }
    
    func onPanGestureRecognizer(sender: UIPanGestureRecognizer) {
        var alphaIncrement: CGFloat = 0.02
        var velocity = sender.velocityInView(self)
        var translation = sender.translationInView(self)
        var location = sender.locationInView(self)
        
        if sender.state == UIGestureRecognizerState.Began {
            blurEffectView.alpha = 0.0
            self.bannerImageView.clipsToBounds = false
            self.parentCollectionView.clipsToBounds = false
            self.clipsToBounds = false
        } else if sender.state == UIGestureRecognizerState.Changed {
            if translation.y >  0 {
                if velocity.y > 0 && blurEffectView.alpha < 1 {
                    blurEffectView.alpha += alphaIncrement
                    if self.scale < 3 {
                        self.scale += 0.08
                        self.blurEffectView.transform = CGAffineTransformMakeScale(self.scale, self.scale)
                        self.bannerImageView.transform = CGAffineTransformMakeScale(self.scale, self.scale)
                    }
                } else if velocity.y < 0 && blurEffectView.alpha > 0 {
                    blurEffectView.alpha -= alphaIncrement
                    if scale > 1 {
                        self.scale -= 0.08
                        self.blurEffectView.transform = CGAffineTransformMakeScale(self.scale, self.scale)
                        self.bannerImageView.transform = CGAffineTransformMakeScale(self.scale, self.scale)
                    }
                }
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            blurEffectView.alpha = 0.0
            scale = 1
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.bannerImageView.transform = CGAffineTransformMakeScale(self.scale, self.scale)
                self.blurEffectView.transform = CGAffineTransformMakeScale(self.scale, self.scale)
            }, completion: { (success: Bool) -> Void in
                self.bannerImageView.clipsToBounds = true
                self.parentCollectionView.clipsToBounds = true
                self.clipsToBounds = true
            })

        }
        
    }

}

extension BudgieProfileHeaderReusableView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("Scrolling")
        var pageIndex = floor(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
}


