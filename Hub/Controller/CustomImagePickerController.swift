//  CustomImagePickerController.swift
//  Hub
//  Created by Alexei Gudimenko on 15/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class CustomImagePickerController: UIImagePickerController {
    //  Sets the nav bar buttons color to white when image picker is displayed
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
