//
//  SignUpViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var fNameTextfield: UITextField!
    @IBOutlet weak var lNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var cPasswordTextfield: UITextField!
    @IBOutlet weak var profilePicture: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable back button
        self.navigationItem.hidesBackButton = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signMeUp(sender: AnyObject) {
        let user = PFUser()
        
        let password    = passwordTextfield.text!
        let password_2  = cPasswordTextfield.text!
        
        if password == password_2 {
            activityIndicator.startAnimating()
            user["firstName"] = fNameTextfield.text!
            user["lastName"] = lNameTextfield.text!
            user.username = emailTextfield.text!
            user.email = emailTextfield.text!
            user.password = password
            let profileImageData = UIImagePNGRepresentation(profilePicture.imageForState(.Normal)!)
            let parseProfileImageFile = PFFile(data: profileImageData!)
            user["profileImage"] = parseProfileImageFile
            
            user.signUpInBackgroundWithBlock {
                (success: Bool, error: NSError?) in
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    let errorMessage = error.userInfo["error"] as? String
                    self.showAlert(errorMessage!)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("signUpSegue", sender: nil)
                }
            }
        } else {
            self.activityIndicator.stopAnimating()
            self.showAlert("Password doesn't match")
        }
    }
    
    @IBAction func addProfilePicture(sender: AnyObject) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        imagePicker.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func openCamera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            openGallary()
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        profilePicture.layer.cornerRadius = 0.5 * profilePicture.bounds.size.width
        profilePicture.clipsToBounds = true
        profilePicture.setImage(image, forState: .Normal)
    }
    
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Sign Up", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        
        self.presentViewController(alertError, animated: true, completion: nil)
    }
}