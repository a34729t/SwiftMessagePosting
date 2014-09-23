//
//  PostTableViewCell.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: PostTableViewCellView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

class PostTableViewCellView: NibDesignable {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
}

