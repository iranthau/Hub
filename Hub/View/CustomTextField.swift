//
//  CustomTextField.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    var image: UIImage?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let border = CALayer()
        let width = CGFloat(1.0)
        
        let imageView = UIImageView();
        
        image = selectImage(self.placeholder!)
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        
        // Create a subview for adding the image so that padding around the image
        // can be set properly.
        let leftView = UIView()
        leftView.addSubview(imageView)
        leftView.frame = CGRectMake(0, 0, 30, 20)
        
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.Always
        
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    // Display the correct icon for each text field based on placeholder texts
    func selectImage(placeholder: String) -> UIImage? {
        var imageName: String?
        
        switch placeholder {
        case "First name", "Last name", "Username", "Nickname":
            imageName = "user.png"
        case "Email":
            imageName = "email.png"
        case "Password", "Confirm password":
            imageName = "lock.png"
        default:
            imageName =  "user.png"
        }
        
        return UIImage(named: imageName!)
    }
}

