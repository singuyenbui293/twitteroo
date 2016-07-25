//
//  newFeedCellTableViewCell.swift
//  twitteroo
//
//  Created by admin on 7/22/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import AFNetworking

class newFeedCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var retweeterLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    @IBOutlet weak var avartarImage: UIImageView!
    
    
    @IBOutlet weak var favCount: UILabel!
    

    @IBOutlet weak var retweetCount: UILabel!
    
    
    var RetweetCount: Int?
    
    
    var tweet: Tweet! {
        didSet {
            contentLabel.text = tweet.text as! String
            fullNameLabel.text = "\(tweet.user!.name!)"
            usernameLabel.text = "@" + (tweet.user!.screename! as String) as String
            
            favCount.text = "\(tweet.favoritesCount)"
            
            retweetCount.text = "\(tweet.retweetCount)"
            avartarImage.layer.cornerRadius = 10
            avartarImage.clipsToBounds = true
            
          
            
            
            avartarImage.setImageWithURL(tweet.user!.profileUrl!)

        }
    }
    
    @IBAction func favAction(sender: AnyObject) {
        
         let parameter = ["id" : tweet.retweetID!]
        
        TwitterClient.sharedInstance.fav(parameter) { (response, error) in
            print("fav that status")
        } 
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
     
     
            
            TwitterClient.sharedInstance.retweetStatus(tweet.retweetID!, completion: { (response, error) -> () in
                if response != nil {
                 self.retweetCount.text = "\(self.tweet.retweetCount + 1)"
                    
                }
            })
       
}
}
