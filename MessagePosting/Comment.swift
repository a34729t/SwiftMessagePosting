//
//  Comment.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var date: NSDate

}
