//
//  PostDetailCommentTableViewCell.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 9/22/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class PostDetailCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: PostDetailCommentTableViewCellView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class PostDetailCommentTableViewCellView: NibDesignable {
    
    @IBOutlet weak var commentTextLabel: UILabel!
    
}
