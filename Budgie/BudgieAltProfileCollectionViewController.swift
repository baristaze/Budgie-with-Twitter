//
//  BudgieAltProfileCollectionViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/29/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

let reuseCellIdentifier = "Cell"
let reuseHeaderTopIdentifier = "Top"
let reuseHeaderBottomIdentifier = "Bottom"

class BudgieAltProfileCollectionViewController: UICollectionViewController {

    private var scale: CGFloat!
    private var headerCell: BudgieHeaderReusableView!
    private var footerCell: BudgieFooterReusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)

        self.collectionView?.panGestureRecognizer.addTarget(self, action: "onCustomPan")
        
        scale = 1.0
    }
    
    func onCustomPan() {
        var point =  self.collectionView?.panGestureRecognizer.locationInView(view)
        var velocity =  self.collectionView?.panGestureRecognizer.velocityInView(view)
        
        if  self.collectionView?.panGestureRecognizer.state == UIGestureRecognizerState.Began {
            
        } else if  self.collectionView?.panGestureRecognizer.state == UIGestureRecognizerState.Changed {
//            println("I'm changing with velocity: \(self.collectionView?.panGestureRecognizer.velocityInView(view))")
            if self.collectionView!.contentOffset.y < 0 && scale < 4.0 {
//                println(scale)
                scale! += 0.05
                headerCell.bgImageView.layer.transform = CATransform3DMakeScale(self.scale, self.scale, 1)
                
            }
        } else if  self.collectionView?.panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            scale = 1.0
            headerCell.layer.transform = CATransform3DMakeScale(1, self.scale, 1)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 2
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if section == 0 {
            return 0
        } else {
            return 100
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    
        cell.backgroundColor = UIColor.budgieBlue()
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //println("Kind" + kind)
        if kind == "UICollectionElementKindSectionHeader" {
            headerCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseHeaderTopIdentifier, forIndexPath: indexPath) as! BudgieHeaderReusableView
            headerCell.backgroundColor = UIColor.redColor()
            headerCell.bgImageView.setImageWithURL(NSURL(string: User.currentUser!.profileBannerUrl!))
            return headerCell
        } else {
            footerCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseHeaderBottomIdentifier, forIndexPath: indexPath) as! BudgieFooterReusableView
            footerCell.backgroundColor = UIColor.greenColor()
            return footerCell
        }
    }

    // MARK: UICollectionViewDelegate

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

extension BudgieAltProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // Getting the Size of Items
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 40, height: 40)
    }
    
    // Getting the Section Spacing
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        
        if section == 0 {
            return 0
        } else {
            return 10
        }
        
    }
    
    
    // Getting the Header & Footter Size
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.size.width, height: 100)
        } else {
            return CGSizeZero
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: self.view.frame.size.width, height: self.view.frame.height * 0.30)
        } else {
            return CGSizeZero
        }
    }
    
    
}

extension BudgieAltProfileCollectionViewController: UIScrollViewDelegate {
    override func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        println("I'm zooming")
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        println("I'm dragging")
    }

}
