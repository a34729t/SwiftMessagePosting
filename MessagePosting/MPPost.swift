//
//  MPPost.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/3/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData

var pfPostDict:Dictionary<NSString,PFObject> = Dictionary()

class MPPost {
    
    var id: String?
    var text: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!

    required init(text:String) {
        self.text = text
        self.createdAt = NSDate()
        trackComposePost(self.text, self.createdAt)
    }
    
    required init(obj: PFObject) {
        if obj.parseClassName == parseClassNamePost {
            self.id = obj.objectId as String
            self.text = obj.objectForKey(parseKeyNameText) as String
            if let commentsPFObject = obj.objectForKey(parseKeyNameComments) {
                let commentsArray = commentsPFObject as [PFObject]
                NSLog("foo")
            }
        } else {
            assertionFailure(":(")
        }
    }
    
    func toParseFormat() -> PFObject {
        var post = PFObject(className:parseClassNamePost)
        post[parseKeyNameText] = self.text
        post[parseKeyNameComments] = []
        return post
    }
    
    func saveToParse(successBlock:(String) -> Void, errorBlock:(NSError!) -> Void) {
        let pfObj:PFObject = self.toParseFormat()
        // ParseObjectTask(pfObject: pfObj, successBlock, errorBlock)
        
        pfObj.saveInBackgroundWithBlock {(success: Bool!, error:NSError!) -> Void in
            if success! {
                successBlock(pfObj.objectId)
                self.id = pfObj.objectId
                self.saveToCoreData()
            } else {
                errorBlock(error)
            }
        }
    }

    // MARK: - Core data
    
    class func update(post:Post, date:NSDate!) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        post.updatedAt = date
        
        var error:NSError?
        managedObjectContext?.save(&error)
        if let realError = error {
            // TODO
        }
    }
    
    func saveToCoreData() -> Post? {
        // 1. Does this post already exist in DB?
        // 2. If so, has it been updated?
        
        if let validId = self.id {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            let entityDescripition = NSEntityDescription.entityForName(coreDataEntityPost, inManagedObjectContext: managedObjectContext)
            let post = Post(entity: entityDescripition, insertIntoManagedObjectContext: managedObjectContext)
            post.text = self.text
            post.createdAt = self.createdAt
            post.updatedAt = self.updatedAt
            post.id = validId
            
            var error:NSError?
            managedObjectContext?.save(&error)
            if let realError = error {
                // TODO
            }
            
            return post
        } else {
            assertionFailure("This should not happen :(")
            return nil
        }
    }
    
    class func findPostInCoreData(post:MPPost, successBlock:(Post) -> Void, failureBlock:(MPPost) -> Void, errorBlock:(NSError!) -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            var fetchRequest = NSFetchRequest(entityName: coreDataEntityPost)
            fetchRequest.predicate = NSPredicate(format: "id == %@", post.id!)
            var error:NSError? = nil
            var result = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
            if result?.count == 1 {
                let post = result?.first as Post
                successBlock(post)
            } else if result?.count == 0 {
                failureBlock(post)
            } else {
                errorBlock(error)
            }
        })
    }
    
    // MARK: - Parse.com
    
    class func getPosts() {
        var query = PFQuery(className: parseClassNamePost)
//        query.includeKey(parseKeyNameComments) // This forces Parse to get Comments for Post (off by default)
        query.orderByAscending(parseKeyNameDate)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if let realError = error {
                // Oh dear -> fire callback
            } else {
                // Stupendous -> fire callback
                for obj in objects {
                    let pfObj = obj as PFObject
                    let post = MPPost(obj: pfObj)
                    
                    let successBlock = {(post coreDataPost:Post) -> Void in
                        println("already exists")
                    }
                    
                    let failureBlock = {(post mpPost:MPPost) -> Void in
                        mpPost.createdAt = pfObj.createdAt as NSDate
                        mpPost.updatedAt = pfObj.updatedAt as NSDate
                        let coreDataPost = mpPost.saveToCoreData()
                    }
                    
                    let errorBlock = {(error:NSError!) -> Void in
                        println("failure to fetch")
                    }
                    
                    MPPost.findPostInCoreData(post, successBlock, failureBlock: failureBlock, errorBlock: errorBlock)
                }
            }
        }
    }
    
}



