//
//  BudgieMenuViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/29/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit


class BudgieMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    private var containerViewOriginalCenter: CGPoint!
    
    @IBAction func onPanGestureRecognizer(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {

        } else if sender.state == UIGestureRecognizerState.Changed {
            println("Transalation: \(translation)")
            if translation.x > 0 {
                var newCenter = containerViewOriginalCenter
                newCenter.x += translation.x
                containerView.center = newCenter
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            if translation.x > 100 {
                var newCenter = containerViewOriginalCenter
                newCenter.x += (self.view.frame.width - 30)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                    self.containerView.center = newCenter
                    }, completion: { (success:Bool) -> Void in
                    
                })
                
            } else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                    self.containerView.center = self.containerViewOriginalCenter
                    }, completion: { (success:Bool) -> Void in
                        
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        containerView.layer.shadowOpacity = 0.8
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        containerViewOriginalCenter = containerView.center

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BudgieMenuViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 6
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("menuProfileCell", forIndexPath: indexPath) as! BudgieMenuProfileCell
            cell.profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!)!)
            cell.nameLabel.text = User.currentUser!.name
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.profileImageView.layer.cornerRadius = 35
            cell.profileImageView.clipsToBounds = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if indexPath.row == 0 {
                cell.imageView!.image = UIImage(named: "Feeds")
                cell.textLabel?.text = "Home Time Line"
            } else if indexPath.row == 1 {
                cell.imageView!.image = UIImage(named: "Mentions")
                cell.textLabel?.text = "Mentions"
            } else if indexPath.row == 2 {
                cell.imageView!.image = UIImage(named: "Search")
                cell.textLabel?.text = "Search"
            } else if indexPath.row == 3 {
                cell.imageView!.image = UIImage(named: "Switch")
                cell.textLabel?.text = "Switch Accounts"
            } else if indexPath.row == 4 {
                cell.imageView!.image = UIImage(named: "Settings")
                cell.textLabel?.text = "Settings"
            } else if indexPath.row == 5 {
                cell.imageView!.image = UIImage(named: "LogOut")
                cell.textLabel?.text = "LogOut"
            }
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
    }
}

extension BudgieMenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {     // User Profile
            if self.tabBarController?.selectedIndex == 3 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                    self.containerView.center = self.containerViewOriginalCenter
                    }, completion: { (success:Bool) -> Void in })
            } else {
                self.tabBarController?.selectedIndex = 3
            }
        } else if indexPath.row == 0 {  // Home TimeLine
            if self.tabBarController?.selectedIndex == 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                    self.containerView.center = self.containerViewOriginalCenter
                    }, completion: { (success:Bool) -> Void in })
            } else {
                self.tabBarController?.selectedIndex = 0
            }
        } else if indexPath.row == 1 {  // Mentions
            if self.tabBarController?.selectedIndex == 1 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                    self.containerView.center = self.containerViewOriginalCenter
                    }, completion: { (success:Bool) -> Void in  })
            } else {
                self.tabBarController?.selectedIndex = 1
            }
        } else if indexPath.row == 2 {  // Search
            println("Selected 2")
            if self.tabBarController?.selectedIndex == 2 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                    self.containerView.center = self.containerViewOriginalCenter
                    }, completion: { (success:Bool) -> Void in  })
            } else {
                self.tabBarController?.selectedIndex = 2
            }
        } else if indexPath.row == 3 {  // Switch Accounts
            var switchAccountVC = storyboard?.instantiateViewControllerWithIdentifier("SwitchAccounts") as! BudgieSwitchAccountsViewController
            self.presentViewController(switchAccountVC, animated: true, completion: { () -> Void in
                
            })
        } else if indexPath.row == 4 {  // Settings
            println("Settings")
        } else if indexPath.row == 5 {  // LogOut
            TwitterClient.sharedInstance.resetClient()
            User.currentUser?.logout()
        }
        
    }
}