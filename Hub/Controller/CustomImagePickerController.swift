//
//  CustomImagePickerController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 15/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//
//  Sets the style of the image picker controller, so that the nav bar buttons
//  are displayed in white font automatically

import UIKit

class CustomImagePickerController: UIImagePickerController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
