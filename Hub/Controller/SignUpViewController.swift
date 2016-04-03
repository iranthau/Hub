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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    var hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable back button
        self.navigationItem.hidesBackButton = true
        activityIndicator.hidesWhenStopped = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signMeUp(sender: AnyObject) {
        let password    = passwordTextfield.text!
        let password_2  = cPasswordTextfield.text!
        
        if password == password_2 {
            activityIndicator.startAnimating()
            let firstName = fNameTextfield.text!.capitalizedString
            let lastName = lNameTextfield.text!.capitalizedString
            let email = emailTextfield.text!
            
            let parseUser = PFUser()
            let user = User(parseUser: parseUser)
            user.setUpParseUser(email, fName: firstName, lName: lastName)
            user.username = email
            user.password = password
            
            let buttonBgImage = profilePicture.imageForState(.Normal)!
            if !buttonBgImage.isEqual(UIImage(named: "profile-pic")) {
                user.setProfileImage(buttonBgImage)
            }
            
            user.signUp(self)
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        profilePicture.hidden = true
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        profilePicture.hidden = false
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let changeInHeight = CGRectGetHeight(keyboardFrame)
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            if show {
                self.bottomConstraint.constant = changeInHeight
            } else {
                self.bottomConstraint.constant = 0
            }
        })
    }
}

extension UIImage {
    var uncompressedPNGData: NSData {
        return UIImagePNGRepresentation(self)!
    }
    
    var highestQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 1.0)!
    }
    
    var highQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.75)!
    }
    
    var mediumQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.5)!
    }
    
    var lowQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.25)!
    }
    
    var lowestQualityJPEGNSData:NSData {
        return UIImageJPEGRepresentation(self, 0.0)!
    }
}