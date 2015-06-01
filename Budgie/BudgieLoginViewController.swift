//
//  ViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/18/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit



class BudgieLoginViewController: UIViewController {
    
    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() { (success: Bool, user: User?, error: NSError?) in
            
            if success && user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                var alert = UIAlertController(title: "Error Login User", message: "Try Again", preferredStyle: UIAlertControllerStyle.Alert)
                var action = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                println(error)
            }
        }
        
    }
    
    @IBOutlet var titleImage: UIImageView!
    @IBOutlet var budgieImage: UIImageView!
    @IBOutlet var loginImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userForProfile = nil
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        self.view.backgroundColor = UIColor.budgieBlue()
        if User.currentUser != nil {
            titleImage.alpha = 0
            budgieImage.alpha = 0
            loginImage.alpha = 0
        } else {
            titleImage.alpha = 1
            budgieImage.alpha = 1
            loginImage.alpha = 1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if User.currentUser != nil {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }

    }


}