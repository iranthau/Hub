//  ViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/12/2015.
//  Copyright © 2015 88Software. All rights reserved.

import UIKit
import Parse

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
        logUserIn()
    }
    
    @IBAction func facebookSignIn(sender: AnyObject) {
        let parseUser = PFUser()
        let user = User(parseUser: parseUser)
        user.logInWithFacebook(self)
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        self.performSegueWithIdentifier("createAccountSegue", sender: nil)
    }
    
    //Create and display an allert. May be move the function to a more centric place later.
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Sign In", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    //Handle keyboard return key(Done, Go etc) function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.userNameInput {
            self.passwordInput.becomeFirstResponder()
        } else if textField == self.passwordInput {
            logUserIn()
            textField.resignFirstResponder()
        }
        return false
    }
    
    //----------------------Private methods---------------------------
    func logUserIn() {
        let username = userNameInput.text!
        let password = passwordInput.text!
        let userDetails = ["username": username, "password": password]
        let parseUser = PFUser()
        let user = User(parseUser: parseUser)
        
        user.logIn(userDetails, vc: self)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

