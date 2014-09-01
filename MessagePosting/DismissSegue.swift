//
//  DismissSegue.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/30/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

@objc(DismissSegue) // HACK: Storyboard needs objective-c linking for custom segues currently
class DismissSegue: UIStoryboardSegue {
   
    override func perform() {
        if let presentingViewController = self.sourceViewController.presentingViewController {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
