//
//  MPPost.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/3/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData

let parseClassNamePost = "Post"
let parseKeyNameText = "text"
let parseKeyNameDate = "date"
let parseKeyNameComments = "comments"

class MPPost {
    
    var id: String?
    var text: String!
    var date: NSDate!

    required init(text:String, date:NSDate) {
        self.text = text
        self.date = date
    }
    
    func toParseFormat() -> PFObject {
        var post = PFObject(className:parseClassNamePost)
        post[parseKeyNameText] = self.text
        post[parseKeyNameDate] = self.date
        return post
    }

    func saveToCoreData() {
        if let validId = self.id {
            // 1. Does this post already exist in DB?
            // 2. If so, has it been updated?
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            let entityDescripition = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
            let post = Post(entity: entityDescripition, insertIntoManagedObjectContext: managedObjectContext)
            post.text = self.text
            post.date = self.date
            post.id = validId
        } else {
            assertionFailure("This should not happen :(")
        }
    }

}