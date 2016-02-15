//
//  ViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 3/12/2015.
//  Copyright © 2015 88Software. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignInViewController: UIViewController {

    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        fbSignInButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        let username = userNameInput.text!
        let password = passwordInput.text!
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let currentUser = PFUser.currentUser()
                self.hubModel.user = self.hubModel.pfUserToUser(currentUser!)
                self.performSegueWithIdentifier("signInSegue", sender: nil)
            } else {
                let errorMessage = error!.userInfo["error"] as? String
                self.showAlert(errorMessage!)
            }
        }
    }
    
    @IBAction func facebookSignIn(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"],
            block: { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                self.showAlert(errorMessage!)
            } else if let user = user {
                if user.isNew {
                    self.performSegueWithIdentifier("createAccountSegue", sender: nil)
                } else {
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
}

