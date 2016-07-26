//
//  User.swift
//  twitteroo
//
//  Created by admin on 7/20/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screename: NSString?
    var profileUrl : NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screename = dictionary["name"] as? String
        
        let profileUrlString = dictionary["profile_image_url"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
        
        
    }
    
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey("currentUserData") as? NSData
                if data != nil {
                    do {
                        var dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                        //print(dictionary)
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        
                    }
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: []) as NSData
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentUserData")
                } catch {
                    print("JSON error")
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "currentUserData")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "currentUserData")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}


