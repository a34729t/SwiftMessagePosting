//
//  ImprovedTextView.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/21/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

public class ImprovedTextView: NibDesignable, UITextViewDelegate {
    
    let minLength:Int = 3
    let maxLength:Int = 140
    let placeholderText = "..."
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charactersLeftLabel: UILabel!
    
    
    var text: String { get { return self.textView.text } }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textView!.delegate = self
        self.noContent()
    }
    
    override public func prepareForInterfaceBuilder() {
        self.noContent()
        self.layoutSubviews()
    }
    
    func noContent() {
        self.textView.textColor = UIColor.grayColor()
        self.textView.text = placeholderText
        self.charactersLeftLabel.text = "\(maxLength) characters left"
    }
    
    // MARK: - UITextView Delegate Methods

    public func textViewDidEndEditing(textView: UITextView) {
        if countElements(textView.text) == 0 {
            self.noContent()
        }
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholderText {
            self.textView.text = ""
        }
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        let oldText = self.textView.text as NSString // hack cause string length stuff is garbage in swift
        
        var newText:NSString!
        // Dismiss keyboard if return
        if text == "\n" {
            newText = oldText
        } else {
            newText = oldText.stringByReplacingCharactersInRange(range, withString: text) as NSString
        }
        
        // Dismiss keyboard if return
        if text == "\n" {
            self.endEditing(true)
        }
        
        // Truncate text entered if too long
        switch newText.length {
        case 0:
            return true
        case 0..<minLength-1:
            self.textView.textColor = UIColor.blackColor()
            self.charactersLeftLabel.text = "\(minLength - newText.length) more characters"
            return true
        case minLength-1..<minLength:
            self.textView.textColor = UIColor.blackColor()
            self.charactersLeftLabel.text = "\(minLength - newText.length) more character"
            return true
        case minLength...maxLength:
            self.textView.textColor = UIColor.blackColor()
            self.charactersLeftLabel.text = "\(maxLength - newText.length) characters left"
            return true
        default:
            self.textView.textColor = UIColor.blackColor()
            self.charactersLeftLabel.text = "0 characters left"
            self.textView.text = newText.substringToIndex(maxLength)
            return false
        }
        
    }
    
}

