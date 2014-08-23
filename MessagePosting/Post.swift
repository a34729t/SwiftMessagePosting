//
//  Post.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation
import CoreData

class Post: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var text: String
    @NSManaged var comments: NSSet

}
