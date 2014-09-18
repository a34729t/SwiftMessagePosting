//
//  MPComment.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/3/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreData

class MPComment {

    var id: String?
    var text: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    var post:Post!
    var pfPost:PFObject!
    
    required init(text:String, post:Post, date:NSDate) {
        self.text = text
        self.createdAt = date
        self.updatedAt = date
        self.post = post
        
        // Add comment to post
        self.pfPost = PFObject(withoutDataWithClassName: parseClassNamePost, objectId: post.id)
        self.pfPost.incrementKey(parseKeyNameNumberComments)
        self.pfPost.addObject(self.toParseFormat(), forKey: parseKeyNameComments) // Add the comment to the post
    }
    
    required init(obj: PFObject) {
        if obj.parseClassName == parseClassNameComment {
            self.id = obj.objectId
            self.text = obj.objectForKey(parseKeyNameText) as String
            self.createdAt = obj.createdAt as NSDate
            self.updatedAt = obj.updatedAt as NSDate
        } else {
            assertionFailure(":(")
        }
    }

    func toParseFormat() -> PFObject {
        var pfComment = PFObject(className:parseClassNameComment)
        pfComment[parseKeyNameText] = self.text
        pfComment[parseKeyNameParent] = self.pfPost
        return pfComment
    }
    
    // MARK: - Core data
    
    func saveToCoreData(post: Post) -> Comment? {
        // 1. Does this post already exist in DB?
        // 2. If so, has it been updated?
        
        if let validId = self.id {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            let entityDescripition = NSEntityDescription.entityForName(coreDataEntityComment, inManagedObjectContext: managedObjectContext)
            let comment = Comment(entity: entityDescripition, insertIntoManagedObjectContext: managedObjectContext)
            comment.text = self.text
            comment.createdAt = self.createdAt
            comment.updatedAt = self.updatedAt
            comment.id = validId
            comment.post = post
            var error:NSError?
            managedObjectContext?.save(&error)
            if let realError = error {
                // TODO
                println("TODO: fail!");
            }
            
            return comment
        } else {
            assertionFailure("This should not happen :(")
            return nil
        }
    }
    
    class func findCommentInCoreData(comment:MPComment, successBlock:(Comment) -> Void, failureBlock:(MPComment) -> Void, errorBlock:(NSError!) -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            var fetchRequest = NSFetchRequest(entityName: coreDataEntityComment)
            fetchRequest.predicate = NSPredicate(format: "id == %@", comment.id!)
            var error:NSError? = nil
            var result = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
            if result?.count == 1 {
                let comment = result?.first as Comment
                successBlock(comment)
            } else if result?.count == 0 {
                failureBlock(comment)
            } else {
                errorBlock(error)
            }
        })
    }
    
    // MARK: - Parse.com
    
    class func getCommentsForPost(post:Post) {
        var query = PFQuery(className: parseClassNameComment)
        query.whereKey(parseKeyNameParent, equalTo:PFObject(withoutDataWithClassName: parseClassNamePost, objectId: post.id))
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
                    let comment = MPComment(obj: pfObj)
                    
                    let successBlock = {(post coreDataComment:Comment) -> Void in
                        println("already exists")
                    }
                    
                    let failureBlock = {(comment mpComment:MPComment) -> Void in
                        let coreDataComment = mpComment.saveToCoreData(post)
                    }
                    
                    let errorBlock = {(error:NSError!) -> Void in
                        println("failure to fetch")
                    }
                    
                    MPComment.findCommentInCoreData(comment, successBlock, failureBlock: failureBlock, errorBlock: errorBlock)
                }
            }
        }
    }
    
    func saveToParse(successBlock:(String) -> Void, errorBlock:(NSError!) -> Void) {
        // We save the post, because it automatically saves the comment
        
        self.pfPost.saveInBackgroundWithBlock({
            (success: Bool!, error:NSError!) -> Void in
            if success! {
                if let parseId = self.toParseFormat().objectForKey(parseKeyNameId) as String! {
                    // save the comment to core data
                    self.id = parseId
                    self.saveToCoreData(self.post)
                    trackComposeComment(self.text, self.createdAt)
                    
                    // update the post
                    MPPost.update(self.post, date: self.updatedAt)
                    
                    // fire success
                    successBlock(parseId)
                }
            } else {
                println("failure to upload")
                errorBlock(error)
            }
        })
    }

}