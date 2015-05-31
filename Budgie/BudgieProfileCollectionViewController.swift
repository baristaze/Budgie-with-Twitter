//
//  BudgieProfileCollectionViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/28/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
let reuseSupplementaryIdentifier = "Header"
var userForProfile: User!

class BudgieProfileCollectionViewController: UICollectionViewController, BudgieProfileHeaderReusableViewDelegate {
    
    private var headerCell: BudgieProfileHeaderReusableView!
    private var topHeaderCell: UICollectionReusableView!
    private let sectionInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    private var profileMenuSelectedIndex = 0
    private let testData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eight", "Ninth", "Tenth"]
    private var userTweets: [Tweet]?
    private var userFriends: [User]?
    private var userGallery: [String]?
    private var didLoadUserTimeLine: Bool = false
    private var didLoadUsermedia: Bool = false
    private var didLoadFriendsList: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userForProfile == nil {
                userForProfile = User.currentUser
        }
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func loadUserData() {
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.Indeterminate, animated: true)
        
        TwitterClient.sharedInstance.userTimeLine(["screen_name":userForProfile.screenName!], completion: { (success, tweets, error) -> () in
            if success {
                self.userTweets = tweets
                println("Tweets in TimeLine \(self.userTweets!.count)")
                self.collectionView?.reloadData()
            } else {
                println(error)
            }
            self.didLoadUserTimeLine = true
            if self.didLoadUserTimeLine && self.didLoadUsermedia && self.didLoadFriendsList { MRProgressOverlayView.dismissOverlayForView(self.view, animated: true) }
            
        })
        
        TwitterClient.sharedInstance.userMedia(["screen_name":userForProfile.screenName!], completion: { (success, media, error) -> () in
            if success {
                self.userGallery = media
                self.collectionView?.reloadData()
            } else {
                println(error)
            }
            self.didLoadUsermedia = true
            if self.didLoadUserTimeLine && self.didLoadUsermedia && self.didLoadFriendsList { MRProgressOverlayView.dismissOverlayForView(self.view, animated: true) }
        })
        
        TwitterClient.sharedInstance.friendsList(["screen_name":userForProfile.screenName!], completion: { (success, friends, error) -> () in
            if success {
                self.userFriends = friends
                self.collectionView?.reloadData()
            } else {
                println(error)
            }
            self.didLoadFriendsList = true
            if self.didLoadUserTimeLine && self.didLoadUsermedia && self.didLoadFriendsList { MRProgressOverlayView.dismissOverlayForView(self.view, animated: true) }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if userForProfile == nil {
            userForProfile = User.currentUser
        }
        didLoadFriendsList = false
        didLoadUsermedia = false
        didLoadUserTimeLine = false
        loadUserData()
//        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

    // MARK: UICollectionViewDataSource
extension BudgieProfileCollectionViewController: UICollectionViewDataSource {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        switch profileMenuSelectedIndex{
        case 0:
            return userTweets?.count ?? 0
            
        case 1:
            return userGallery?.count ?? 0
            
        case 2:
            return userFriends?.count ?? 0
            
        default:
            return 10
            
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch profileMenuSelectedIndex{
        
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellUserTweets", forIndexPath: indexPath) as! BudgieProfileUserTweetsCell
            cell.tweet = self.userTweets![indexPath.row]
            cell.layer.borderColor = UIColor.budgieBlue().CGColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 5
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellGallery", forIndexPath: indexPath) as! BudgieProfileGalleryCell
            cell.imageUrl = userGallery![indexPath.row]
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellFriends", forIndexPath: indexPath) as! BudgieProfileFriendsCell
            cell.friend = userFriends![indexPath.row]
            cell.layer.cornerRadius = 5
            cell.layer.borderColor = UIColor.budgieBlue().CGColor
            cell.layer.borderWidth = 0.5
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
    
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementaryCell: BudgieProfileHeaderReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseSupplementaryIdentifier, forIndexPath: indexPath) as! BudgieProfileHeaderReusableView
        supplementaryCell.user = userForProfile
        supplementaryCell.scrollFrameWidth = self.view.frame.width
        supplementaryCell.delegate = self
        return supplementaryCell
    }
}

    // MARK: UICollectionViewDelegate
extension BudgieProfileCollectionViewController: UICollectionViewDataSource {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if profileMenuSelectedIndex == 2 {
            userForProfile = userFriends![indexPath.row]
            self.loadUserData()
        }
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

// MARK: UICollectionViewDelegateFlowLayout

extension BudgieProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // Getting the Size of Items
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        switch profileMenuSelectedIndex{
        case 0:
            return CGSize(width: (self.collectionView!.frame.width - 16), height: 160)
            
        case 1:
            return CGSize(width: ( (self.collectionView!.frame.width - 3 - 16) / 4 ), height: ( (self.collectionView!.frame.width - 3 - 16) / 4 ) )
            
        case 2:
            return CGSize(width: (self.collectionView!.frame.width - 16), height: 50)
            
        default:
            return CGSize(width: 40, height: 40)
            
        }
        
    }
    
    // Getting the Section Spacing
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        switch profileMenuSelectedIndex{
        case 0:
            return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            
        case 1:
            return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            
        case 2:
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            
        default:
            return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        switch profileMenuSelectedIndex{
        case 0:
            return 0
            
        case 1:
            return 1
            
        case 2:
            return 0

        default:
            return 10
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        switch profileMenuSelectedIndex{
        case 0:
            return 10
            
        case 1:
            return 1
            
        case 2:
            return 1

        default:
            return 10
            
        }
        
    }
    
}

// MARK: UIScrollViewDelegate
extension BudgieProfileCollectionViewController: BudgieProfileHeaderReusableViewDelegate {
    func budgieProfileHeaderReusableView(budgieProfileHeaderReusableView: BudgieProfileHeaderReusableView, segmentedControl: UISegmentedControl, didChangeSelectedIndex index: Int) {
        profileMenuSelectedIndex = index
        println(profileMenuSelectedIndex)
        self.collectionView?.reloadData()
    }
}



