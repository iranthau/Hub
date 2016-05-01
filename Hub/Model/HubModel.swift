//  HubModel.swift
//  Hub
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit

class HubModel {
    
    var currentUser: User?
    
    private init() {
        
    }
    
    private struct Static {
        static var instance: HubModel?
    }
    
    class var sharedInstance: HubModel {
        if !(Static.instance != nil) {
            Static.instance = HubModel()
        }
        return Static.instance!
    }
    
    func setCurrentUser(user: User) {
        currentUser = user
    }
    
    /* Build an alert controller with camera and gallery as default options  */
    func buildImagePickAlertController(imagePicker: UIImagePickerController, view: UIViewController) -> UIAlertController {
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
    private func openGallary(imagePicker: UIImagePickerController, view: UIViewController) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            view.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            
        }
    }
    
    /* Opens the camera if the camera is available. Otherwise it will open the gallery */
    private func openCamera(imagePicker: UIImagePickerController, view: UIViewController) {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            view.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            openGallary(imagePicker, view: view)
        }
    }    
}