//
//  TwitterClient.swift
//  twitteroo
//
//  Created by admin on 7/20/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import BDBOAuth1Manager
import UIKit



class TwitterClient: BDBOAuth1SessionManager {
    
 
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "KT13ueMlbLzd9nYExsLMyJkpF", consumerSecret: "V4MbDSASR9Q13dqSFIFEhtBxG2wNKZo7ACvKNT4SJYDGmCvdL8")
    
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError)->()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitteroo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url) // this open URL can use to open safari, map, or any other app
        }) { (error: NSError!) in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl (url: NSURL) {
        
        deauthorize()
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("I got the access token")
            self.currentAccount({ (user: User) in
                
                User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
        
        }) { (error: NSError!) in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }
    
    func logout () {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogout", object: nil)
        
    }
    
    
    func postNewTweet(params: NSDictionary, completion: (response: AnyObject?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
             
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                print(error.localizedDescription)
        }
    }

    //MARK: Retweet
    
    func retweetStatus(tweetID: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(tweetID).json", parameters: nil, success: { (task: NSURLSessionDataTask, reponse:AnyObject?) in
            completion(response: reponse, error: nil)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("failed to retweet: \(error)")
                completion(response: nil, error: error)
        })
    }
    
    
    func unretweet(tweetID: NSNumber, completion: (response: AnyObject?, error: NSError?) -> ()) {
        POST("1.1/statuses/destroy/\(tweetID).json", parameters: nil, success: { (task: NSURLSessionDataTask, reponse:AnyObject?) in
            completion(response: reponse, error: nil)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("failed to retweet: \(error)")
                completion(response: nil, error: error)
        })
    }
    
    //MARK: Fav
    
    
    func fav (params: NSDictionary , completion: (response: AnyObject?, error: NSError?) -> ()) {

        POST("1.1/favorites/create.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    
    
    //MARK: GET Info

    
    func homeTimeline(success:([Tweet]) -> (), failure: (NSError)->()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                
                failure(error)
        })
        
    }
    
    func currentAccount(success:(User) -> (), failure: (NSError)->()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
}