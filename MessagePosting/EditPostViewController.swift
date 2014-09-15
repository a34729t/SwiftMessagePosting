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
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textFieldLengthLabel: UILabel!
    //    @IBOutlet weak var placeholderTextLabel: UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    var post:Post? = nil
    
    let minLength:Int = 3
    let maxLength:Int = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldLengthLabel.text = "\(maxLength) characters left"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        let oldText = textView.text as NSString // hack cause string length stuff is garbage in swift
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: text) as NSString
        
        // Dismiss keyboard if return
        if text == "\n" {
            self.view.endEditing(true)
        }
        
        // Enable placeholder text if no text entered
        /*
        if newText.length == 0 {
        placeholderTextLabel.hidden = false
        } else {
        placeholderTextLabel.hidden = true
        }
        */
        
        // Truncate text entered if too long
        if newText.length <= maxLength {
            textFieldLengthLabel.text = "\(maxLength - newText.length) characters left"
            return true
        } else {
            textFieldLengthLabel.text = "0 characters left"
            textView.text = newText.substringToIndex(maxLength)
            return false
        }
    }
    
    func createPost() {
        let post = MPPost(text: textView.text)
        
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
            // TODO: Move this into Model object
            
            let comment = MPComment(text: textView.text, post: realPost, date: NSDate()) // Add to post inside
            let (pfComment, pfPost):(PFObject, PFObject) = comment.commentAndPostInParseFormat() as (PFObject, PFObject)
            
            pfPost.saveInBackgroundWithBlock({
                (success: Bool!, error:NSError!) -> Void in
                if success! {
                    if let parseId = pfComment.objectForKey(parseKeyNameId) as String! {
                        // save the comment to core data
                        comment.id = parseId
                        comment.saveToCoreData(realPost)
                        trackComposeComment(comment.text, comment.createdAt)
                        
                        // update the post
                        MPPost.update(realPost, date: comment.updatedAt)

                    }
                } else {
                    println("failure to upload")
                }
            })
            
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        let textLength = countElements(textView.text!)
        if  minLength <= textLength && textLength <= maxLength  {
            if let realPost:Post = self.post {
                addCommentToPost()
            } else {
                createPost()
            }
            navigationController.popViewControllerAnimated(true)
        } else {
            // Put up an alert view
            var alert = UIAlertController(title: "Warning", message: "You gotta type something!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}