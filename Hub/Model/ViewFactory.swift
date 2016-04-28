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
            label.textColor = UIColor.whiteColor()
        }
    }
    
    class func setTextViewPlaceholder(placeholder: String, text: String?, textView: UITextView) {
        if text == nil || text == "When can others contact you?" {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        } else {
            textView.text = text
        }
    }
    
    class func backGroundColor(contactType: ContactType) -> UIColor {
        switch contactType {
            case ContactType.Phone:
                return UIColor(red: 240/255.0, green: 148/255.0, blue: 27/255.0, alpha: 1)
            case ContactType.Email:
                return UIColor(red: 234/255.0, green: 176/255.0, blue: 51/255.0, alpha: 1)
            case ContactType.Address:
                return UIColor(red: 212/255.0, green: 149/255.0, blue: 225/255.0, alpha: 1)
            case ContactType.Social:
                return UIColor(red: 138/255.0, green: 194/255.0, blue: 81/255.0, alpha: 1)
        }
    }
    
    class func setTabBarItemImageColorToOriginal(items: [UITabBarItem]) {
        for item in items {
            if let image = item.image {
                item.image = image.imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
}
