//
//  TweetsViewController.swift
//  twitteroo
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit

@objc protocol TweetsViewControllerDelegate {
    optional func tweetsViewControllerDelegate (filterVC: TweetsViewController, didUpdateFilter filter: Tweet)
}

class TweetsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var twiits: [Tweet]!

    @IBOutlet weak var tweetTextField: UITextField!
    
    @IBAction func sendTweet(sender: AnyObject) {
        
               

    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logOutButtonAction(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    weak var delegate: TweetsViewControllerDelegate?
    
     let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        
            
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.refreshControl.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: UIControlEvents.ValueChanged)

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            
            self.twiits = tweets
            
                      
             self.tableView.reloadData()
        }) { (error: NSError) in
                print(error.localizedDescription)

        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            
            self.twiits = tweets
            
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: NSError) in
            print(error.localizedDescription)
            
        }

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if twiits !=  nil {
            return twiits.count
        } else {
            return 0
            
            
        }
        
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newFeedCell", forIndexPath:  indexPath) as! newFeedCellTableViewCell
       
        cell.tweet = twiits[indexPath.row]
        
      
                
        return cell
    }
    
    
    
  

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailsView" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let twiit = twiits[indexPath!.row]
            let detailViewController = segue.destinationViewController as! DetailTweetViewController
            detailViewController.twiit = twiit
        } else if segue.identifier == "updateTweet" {
            let controller = segue.destinationViewController as! updateStatusViewController
            
        }
        
 
      
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
