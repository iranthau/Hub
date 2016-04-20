//  CustomTextField.swift
//  Hub
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit

class CustomTextField: UITextField {
    var image: UIImage?
    let border = CALayer()
    let width = CGFloat(1.0)
    let imageView = UIImageView();
    let customLeftView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        image = selectImageBasedOnPlaceholder(self.placeholder!)
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        
        setCustomLeftViewOfTextField()
        setCustomBorder()
    }
    
    func selectImageBasedOnPlaceholder(placeholder: String) -> UIImage? {
        switch placeholder {
            case "First name", "Last name", "Username", "Nickname":
                return UIImage(named: "user.png")
            case "Email":
                return UIImage(named: "email.png")
            case "Password", "Confirm password":
                return UIImage(named: "lock.png")
            default:
                return UIImage(named: "")
        }
    }
    
    func setCustomLeftViewOfTextField() {
        customLeftView.addSubview(imageView)
        customLeftView.frame = CGRectMake(0, 0, 30, 20)
        self.leftView = customLeftView
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func setCustomBorder() {
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

