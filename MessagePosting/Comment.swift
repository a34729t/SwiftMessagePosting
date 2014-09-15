//
//  Comment.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/3/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var createdAt: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var text: String
    @NSManaged var post: Post

}
