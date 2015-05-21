//
//  BudgieComposeTweetViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/20/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        println("Tweet Sent")
        TwitterClient.sharedInstance.sendTweet(textView.text, replyToTweetID: responseToId) { (tweet, error) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    private let blueColor: UIColor = UIColor(red: (88.0 / 255.0), green: (145.0 / 255.0), blue: (211.0 / 255.0), alpha: 1)
    private let yellowColor: UIColor = UIColor(red: (252.0 / 255.0), green: (248.0 / 255.0), blue: (197.0 / 255.0), alpha: 1)
    private let greenColor: UIColor = UIColor(red: (184.0 / 255.0), green: (233.0 / 255.0), blue: (134.0 / 255.0), alpha: 1)
    var screenName: String?
    var responseToId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = User.currentUser!
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        
        profileImageView.setImageWithURL(NSURL(string: currentUser.profileImageUrl!)!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        nameLabel.text = currentUser.name
        screenNameLabel.text = "@" + currentUser.screenName!
        
        textView.delegate = self
        textView.clearsOnInsertion = true
        textView.layer.borderColor = blueColor.CGColor
        textView.layer.borderWidth = 3
        textView.layer.cornerRadius = 8
        textView.resignFirstResponder()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = "140"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if responseToId != nil { textView.becomeFirstResponder() }
    }

}


// MARK: UITextViewDelegate

extension BudgieComposeTweetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = responseToId != nil ? "@" + screenName! + " " :  ""
        textView.textColor = UIColor.darkGrayColor()
    }
    
    func textViewDidChange(textView: UITextView) {
        println("Change Detected: \(count(textView.text))")
        self.navigationItem.title = "\(140 - count(textView.text))"
    }
}