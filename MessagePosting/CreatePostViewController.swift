//
//  CreatePostViewController.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData
import UIKit

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textFieldLengthLabel: UILabel!
    @IBOutlet weak var placeholderTextLabel: UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
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
        
        // Enable placeholder text if no text entered
        if newText.length == 0 {
            placeholderTextLabel.hidden = false
        } else {
            placeholderTextLabel.hidden = true
        }
        
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
        let entityDescripition = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        let post = Post(entity: entityDescripition, insertIntoManagedObjectContext: managedObjectContext)
        post.text = textView.text
        post.date = NSDate()
        managedObjectContext!.save(nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        let textLength = countElements(textView.text!)
        if  minLength <= textLength && textLength <= maxLength  {
            createPost()
            navigationController.popViewControllerAnimated(true)
        } else {
            // Put up an alert view
            var alert = UIAlertController(title: "Warning", message: "Note must have content!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
