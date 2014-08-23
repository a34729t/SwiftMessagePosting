//
//  PostTableViewCell.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/17/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
        // lazy so it doesn't get set up until init is ready for it
    lazy var cellLabel:UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.numberOfLines=0
        label.font=UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
      return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellLabel)
        //frame cannot be set until it knows its superview
        cellLabel.frame=CGRectInset(bounds, 15.0, 0.0)
        
        let bindings=["cellLabel":cellLabel]
        
        // metrics aren't used, this is an example of what could be set
        let metrics = [
            "margin": 12,
            "leftMargin": 16,
            "lineMargin": 14
        ]
        /*
        swift doesn't seem to include NSDictionaryOfVariableBindings
        you have to create the 'views' dictionary manually
        NSLayoutAttributeHeight is now NSLayoutAttribute.Height
        NSLayoutRelationGreaterThanOrEqual is now NSLayoutRelation.GreaterThanOrEqual
        NOTE for visual format you need addConstraints <-plural
        */
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[cellLabel]-15-|", options: nil, metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[cellLabel]-15-|", options: nil, metrics: metrics, views: bindings))
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 14))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated) // don't select?
////
////        // Configure the view for the selected state
//    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

}
