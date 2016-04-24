//  HubModel.swift
//  Hub
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit
import Parse
import ParseFacebookUtilsV4

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
    
    func handleFacebookSignUp(parseUser: PFUser, signInVC: SignInViewController) {
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler {
            (connection, result, error: NSError!) -> Void in
            if(error != nil) {
                let errorMessage = error.localizedDescription
                signInVC.showAlert(errorMessage)
            } else if(result != nil) {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                let fName = result["first_name"]! as! String
                let lName = result["last_name"]! as! String
                let email = result["email"]! as! String
                let user = User(parseUser: parseUser)
                let id = result["id"]! as! String
                user.buildParseUser(email, fName: fName, lName: lName)
                self.currentUser = user
                
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let profileImage = self.readProfileImageFromFacebook(id)
                    user.setProfileImage(profileImage)
                    self.uploadUserDetailsToParse(user)
                }
            }
        }
    }
    
    func uploadUserDetailsToParse(user: User) {
        let pfUser = user.matchingParseObject
        pfUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if(success) {
                print("success")
            }
        }
    }
    
    /* Read the profile picture data from facebook when given the user ID */
    func readProfileImageFromFacebook(userID: String) -> UIImage {
        let userProfileUrl = "https://graph.facebook.com/\(userID)/picture?type=large"
        let profilePictureUrl = NSURL(string: userProfileUrl)!
        let profilePicturedata = NSData(contentsOfURL: profilePictureUrl)!
        return UIImage(data: profilePicturedata)!
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    //------------------Private Method-----------------------
    
    /* Opens the photo gallery */
    func openGallary(imagePicker: UIImagePickerController, view: UIViewController) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            view.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            
        }
    }
    
    /* Opens the camera if the camera is available. Otherwise it will open the gallery */
    func openCamera(imagePicker: UIImagePickerController, view: UIViewController) {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            view.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            openGallary(imagePicker, view: view)
        }
    }    
}