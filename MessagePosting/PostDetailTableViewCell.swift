//
//  PostDetailTableViewCell.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/26/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: PostDetailTableViewCellView!
    
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

class PostDetailTableViewCellView: NibDesignable {
    
    @IBOutlet weak var postTextLabel: UILabel!
    
//    let lightGreyColor:UIColor = UIColor(white: 247/255, alpha: 1)
    
}
