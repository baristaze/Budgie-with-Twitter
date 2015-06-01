//
//  BudgieSwitchAccountsViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/31/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieSwitchAccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    private var users: [User]?
    private var accessTokens: [BDBOAuth1Credential]?
    private var userIds: [String]?
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        TwitterClient.sharedInstance.loadUsersFromLoggedUserArray { (userIds, accessTokens, users) -> () in
            println("userIds: \(userIds.count) accessTokens: \(accessTokens.count) users: \(users.count)")
            self.users = users
            self.accessTokens = accessTokens
            self.userIds = userIds
            self.tableView.reloadData()
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: UITableViewDataSource

extension BudgieSwitchAccountsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users!.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchAccountsCell", forIndexPath: indexPath) as! BudgieSwitchAccountsCell
        if indexPath.row == users!.count {
            cell.addUserImage = UIImage(named: "AddUser")
            cell.profileImageView.layer.borderWidth = 0
        } else {
            cell.user = users![indexPath.row]
            cell.profileImageView.layer.borderWidth = 2
        }
        return cell
    }
}

// MARK: UITableViewDelegate

extension BudgieSwitchAccountsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            TwitterClient.sharedInstance.deleteUserFromLoggedUsers(indexPath.row)
            TwitterClient.sharedInstance.loadUsersFromLoggedUserArray { (userIds, accessTokens, users) -> () in
                println("userIds: \(userIds.count) accessTokens: \(accessTokens.count) users: \(users.count)")
                self.users = users
                self.accessTokens = accessTokens
                self.userIds = userIds
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if indexPath.row == users!.count {
            
            User.currentUser?.logout()
        } else {
            TwitterClient.sharedInstance.saveUserToLoggedUsers(accessTokens![indexPath.row], response: users![indexPath.row].dictionary!)
            User.currentUser?.switchUser(accessTokens![indexPath.row], newUser: users![indexPath.row])
        }
    }
}