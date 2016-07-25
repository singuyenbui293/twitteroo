//
//  Tweet.swift
//  twitteroo
//
//  Created by admin on 7/20/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageUrl: NSURL?
    var user: User?
    var retweetID : NSNumber?
    var retweeted: Bool?
    var favorited: Bool?
    
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = dictionary["favourites_count"] as! Int
        retweetID = (dictionary["id"] as? NSNumber) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool)!
        favorited = (dictionary["favorited"] as? Bool)!
        
       user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
             let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
            
        }
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
