//
//  updateStatusViewController.swift
//  twitteroo
//
//  Created by admin on 7/23/16.
//  Copyright © 2016 NguyenBui. All rights reserved.
//

import UIKit
import AFNetworking

class updateStatusViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var newTweetTextView: UITextView!
    
    @IBAction func sendButton(sender: AnyObject) {
        
        let parameter = ["status" : newTweetTextView.text!]
        
        TwitterClient.sharedInstance.postNewTweet(parameter) { (response, error) in
            if error == nil {
                print("hoorayy")
            } else {
                print("holly shit OhMahGAh what do i do now")
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
   
    }
    
    var CurrentUser: User!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTweetTextView.text = "enter your tweet"
        newTweetTextView.textColor = UIColor.yellowColor()
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) in
            let currentUser = user
            
            self.CurrentUser = currentUser
            print(self.CurrentUser.name)
            self.fullNameLabel.text = self.CurrentUser.name as? String
            self.avatarImage.setImageWithURL(self.CurrentUser.profileUrl!)
            self.username.text = self.CurrentUser.screename as? String
            
            
        }) { (error: NSError) in
                print(error.localizedDescription)
            
        }
        
        newTweetTextView.becomeFirstResponder()
        
        
        
        newTweetTextView.selectedTextRange = newTweetTextView.textRangeFromPosition(newTweetTextView.beginningOfDocument, toPosition: newTweetTextView.beginningOfDocument)
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = newTweetTextView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            newTweetTextView.text = "Placeholder"
            newTweetTextView.textColor = UIColor.lightGrayColor()
            
            newTweetTextView.selectedTextRange = newTweetTextView.textRangeFromPosition(newTweetTextView.beginningOfDocument, toPosition: newTweetTextView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if newTweetTextView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            newTweetTextView.text = nil
            newTweetTextView.textColor = UIColor.blackColor()
        }
        
        return true
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
