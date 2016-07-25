//
//  LoginViewController.swift
//  twitteroo
//
//  Created by admin on 7/20/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.login({
            print("I've logged in!")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
            
        }) { (error: NSError) in
                print(error.localizedDescription)
            
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
