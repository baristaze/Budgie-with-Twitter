//
//  BudgieTweetDetailsViewController.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/19/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieTweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweet: Tweet!
    
    private let budgieDetailHeaderCellReuseIdentifier = "budgieDetailHeaderCell"
    private let budgieDetailsCountersCellReuseIdentifier = "budgieDetailsCountersCell"
    private let budgieDetailsActionsCellReuseIdentifier = "budgieDetailsActionsCell"
    private let budgieDetailsEmptyCellReuseIdentifier = "budgieDetailsEmptyCell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.backgroundColor = UIColor.greenColor()
        tableView.reloadData()
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

//MARK: UITableViewDelegate

extension BudgieTweetDetailsViewController: UITableViewDelegate {
    
}

//MARK: UITableViewDataSource

extension BudgieTweetDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorColor = UIColor.clearColor()
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailHeaderCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsHeaderCell
            cell.tweet = self.tweet
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailsCountersCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsCountersCell
            cell.tweet = self.tweet
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailsActionsCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsActionsCell
            cell.tweet = self.tweet
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(budgieDetailsEmptyCellReuseIdentifier, forIndexPath: indexPath) as! BudgieDetailsEmptyCell
            cell.tweet = self.tweet
            return cell
        }
    }
    
}