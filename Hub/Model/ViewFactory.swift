//  ViewFactory.swift
//  Hub
//  Created by Irantha Rajakaruna on 20/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit

class ViewFactory {
    class func hidden() -> UIColor {
        return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)
    }
    
    class func circularImage(imageView: UIImageView) {
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
    
    class func setCellLabelPlaceholder(placeholder: String, text: String?, label: UILabel) {
        if text == nil {
            label.text = placeholder
            label.textColor = UIColor.lightGrayColor()
        } else {
            label.text = text
            label.textColor = UIColor.blackColor()
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
    
    /* Build an alert controller with camera and gallery as default options  */
    class func buildImagePickAlertController(imagePicker: UIImagePickerController, view: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera(imagePicker, view: view)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary(imagePicker, view: view)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { UIAlertAction in }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    //------------------Private methods-----------------------
    
    /* Opens the photo gallery */
    private class func openGallary(imagePicker: UIImagePickerController, view: UIViewController) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            view.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /* Opens the camera if the camera is available. Otherwise it will open the gallery */
    private class func openCamera(imagePicker: UIImagePickerController, view: UIViewController) {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            view.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            openGallary(imagePicker, view: view)
        }
    }
}
