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
        TwitterClient.sharedInstance.loginWithCompletion() { (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle error
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        self.view.backgroundColor = UIColor(red: (88.0 / 255.0), green: (145.0 / 255.0), blue: (211.0 / 255.0), alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.

    }


}