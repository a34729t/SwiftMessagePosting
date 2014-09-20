//
//  ViewPostTableViewCell.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/26/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class ViewPostTableViewCell: UITableViewCell {

    let lightGreyColor:UIColor = UIColor(white: 247/255, alpha: 1)
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = lightGreyColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
