//
//  EditPostViewController.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData
import UIKit

class EditPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var improvedTextView: ImprovedTextView!
    @IBOutlet weak var textViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    var post:Post? = nil
    
    let minLength:Int = 3
    let maxLength:Int = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPost() {
        let post = MPPost(text: improvedTextView.text)
        
        let successBlock = {(objectId parseId:String) -> Void in
            // TODO
        }
        let errorBlock = {(error:NSError!) -> Void in
            println("post: failure to upload")
        }
        
        post.saveToParse(successBlock, errorBlock)
    }
    
    func addCommentToPost() {
        if let realPost:Post = self.post {
            let comment = MPComment(text: improvedTextView.text, post: realPost, date: NSDate()) // Add to post inside

            let successBlock = {(objectId parseId:String) -> Void in
                // TODO
            }
            let errorBlock = {(error:NSError!) -> Void in
                println("post: failure to upload")
            }
            
            comment.saveToParse(successBlock, errorBlock)
        } else {
            // TODO another serious error
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        let textLength = countElements(improvedTextView.text)
        if  minLength <= textLength && textLength <= maxLength  {
            if let realPost:Post = self.post {
                addCommentToPost()
            } else {
                createPost()
            }
            navigationController!.popViewControllerAnimated(true)
        } else {
            // Put up an alert view
            var alert = UIAlertController(title: "Warning", message: "You gotta type something!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // NOTE: Below is adapted from Apple: https://developer.apple.com/library/ios/samplecode/UICatalog/Listings/Swift_UICatalog_TextViewController_swift.html
    
    // MARK: Keyboard Event Notifications
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    // MARK: Convenience
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // The text view should be adjusted, update the constant for this constraint.
        textViewBottomLayoutGuideConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        let selectedRange = self.improvedTextView.textView.selectedRange
        self.improvedTextView.textView.scrollRangeToVisible(selectedRange)
    }
    
}