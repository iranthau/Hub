//  ViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/12/2015.
//  Copyright © 2015 88Software. All rights reserved.

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var backgroundLayer: UIView!
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        fbSignInButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        backgroundLayer.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //set delegates to handle keyboard events for each text field
        userNameInput.delegate = self
        passwordInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signIn(sender: AnyObject) {
        let username = userNameInput.text!
        let password = passwordInput.text!
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let currentUser = PFUser.currentUser()!
                self.hubModel.currentUser = User(parseUser: currentUser)
                self.hubModel.currentUser!.buildUser()
                self.performSegueWithIdentifier("signInSegue", sender: nil)
            } else {
                let errorMessage = error!.userInfo["error"] as? String
                self.showAlert(errorMessage!)
            }
        }
    }
    
    @IBAction func facebookSignIn(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(
            ["public_profile", "email"], block: {
                (user: PFUser?, error: NSError?) -> Void in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as? String
                    self.showAlert(errorMessage!)
                } else if let user = user {
                    let currentUser = PFUser.currentUser()!
                    if user.isNew {
                        self.hubModel.handleFacebookSignUp(currentUser, signInVC: self)
                        self.performSegueWithIdentifier("createAccountSegue", sender: nil)
                    } else {
                        self.hubModel.currentUser = User(parseUser: currentUser)
                        self.hubModel.currentUser!.buildUser()
                        self.performSegueWithIdentifier("signInSegue", sender: nil)
                    }
                } else {
                    self.showAlert("Sign up error.")
                }
        })
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        self.performSegueWithIdentifier("createAccountSegue", sender: nil)
    }
    
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Sign In", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    //handle the 'return' key events: move to next or go to sign in - A. G.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.userNameInput {
            
            self.passwordInput.becomeFirstResponder()
            
        } else if textField == self.passwordInput {
            
            let username = userNameInput.text!
            let password = passwordInput.text!
            
            PFUser.logInWithUsernameInBackground(username, password: password) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    let currentUser = PFUser.currentUser()!
                    self.hubModel.currentUser = User(parseUser: currentUser)
                    self.hubModel.currentUser!.buildUser()
                    self.performSegueWithIdentifier("signInSegue", sender: nil)
                } else {
                    let errorMessage = error!.userInfo["error"] as? String
                    self.showAlert(errorMessage!)
                }
            }
            
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

