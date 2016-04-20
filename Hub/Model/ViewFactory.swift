//  ViewFactory.swift
//  Hub
//  Created by Irantha Rajakaruna on 20/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit

class ViewFactory {
    class func hideTableViewSeparator(tableView: UITableView) {
        tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)
    }
    
    class func makeImageViewRound(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.clipsToBounds = true
    }
    
    class func setLabelPlaceholder(placeholder: String, text: String?, label: UILabel) {
        if text == nil {
            label.text = placeholder
            label.textColor = UIColor.lightGrayColor()
        } else {
            label.text = text
        }
    }
    
    class func setTextViewPlaceholder(placeholder: String, text: String?, textView: UITextView) {
        if text == nil {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        } else {
            textView.text = text
        }
    }
}
