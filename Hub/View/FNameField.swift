//
//  CustomTextField.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import UIKit

class FNameField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let border = CALayer()
        let width = CGFloat(1.0)
        
        let imageView = UIImageView();
        let image = UIImage(named: "bg-img.png");
        imageView.image = image;
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewMode.Always
        
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
