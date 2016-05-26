//  SignUpViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

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
        
        self.navigationItem.hidesBackButton = true
        activityIndicator.hidesWhenStopped = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signMeUp(sender: AnyObject) {
        let password_1    = passwordTextfield.text!
        let password_2  = cPasswordTextfield.text!
        
        if password_1 == password_2 {
            activityIndicator.startAnimating()
            let buttonBgImage = profilePicture.imageForState(.Normal)!
            let fristName = fNameTextfield.text!.capitalizedString
            let lastName = lNameTextfield.text!.capitalizedString
            let email = emailTextfield.text!
            let user = User(firstName: fristName, lastName: lastName, email: email)
            user.password = password_1
            if !buttonBgImage.isEqual(UIImage(named: "profile-pic")) {
                user.setProfilePicture(buttonBgImage)
            }
            user.signMeUp {
                (user, error) in
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(error)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.hubModel.currentUser = user
                    self.performSegueWithIdentifier("signUpSegue", sender: nil)
                }
            }
        } else {
            self.showAlert("Password doesn't match")
        }
    }
    
    @IBAction func addProfilePicture(sender: AnyObject) {
        let alert = ViewFactory.buildImagePickAlertController(imagePicker, view: self)
        imagePicker.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        profilePicture.layer.cornerRadius = 0.5 * profilePicture.bounds.size.width
        profilePicture.clipsToBounds = true
        profilePicture.setImage(image, forState: .Normal)
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
    
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Sign Up", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    //-----------------------Private methods---------------------------
    
    private func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let changeInHeight = CGRectGetHeight(keyboardFrame)
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            if show {
                self.bottomConstraint.constant = changeInHeight * 0.8
            } else {
                self.bottomConstraint.constant = 0
            }
        })
    }
}

/* Upload a low quality version of the profile picture to parse to avoid big data handling
 * and longer waiting times. */
extension UIImage {
    var lowQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.25)!
    }
}