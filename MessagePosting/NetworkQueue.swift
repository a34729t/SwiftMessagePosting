//
//  NetworkQueue.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/3/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

// NOTE: All parse stuff should go in here?

import CoreData

class ParseObjectTask {
    
    var obj:PFObject!
    var successBlock:(String) -> Void
    var errorBlock:(NSError!) -> Void
    
    required init(pfObject:PFObject, success:(String) -> Void, error:(NSError!) -> Void) {
        self.obj = pfObject
        self.successBlock = success
        self.errorBlock = error
        ParseObjectTaskQueue.sharedInstance.add(self)
    }
    
//    required init(comment:Comment, success:(String) -> Void, error:(NSError!) -> Void)
}

class ParseObjectTaskQueue {
    
    // NOTE: Parse not allow disabling or tweaking exponential backoff :(
    // It also appears Parse documentation/tech support is useless.
    
    class var sharedInstance:ParseObjectTaskQueue {
        struct Singleton {
            static let instance = ParseObjectTaskQueue()
        }
        return Singleton.instance
    }
    
    private var queue:Array<ParseObjectTask> = []
    let dispatchQueue:dispatch_queue_t = dispatch_queue_create("com.flacco.myqueue", nil);
    
    func add(task:ParseObjectTask) {
        dispatch_sync(dispatchQueue, {
            self.queue.append(task)
        })
        self.flush()
    }
    
    func flush() {
        dispatch_sync(dispatchQueue, {
            if let task = self.queue.first {
                task.obj.saveInBackgroundWithBlock {(success: Bool!, error:NSError!) -> Void in
                    if success! {
                        task.successBlock(task.obj.objectId)
                        self.queue.removeAtIndex(0)
                        self.flush()
                    } else {
                        task.errorBlock(error)
                        // NOTE: Abort, and don't attempt to flush anything else
                        // TODO: Decide what should happen!
                    }
                }

            }
        })
    }
    
}