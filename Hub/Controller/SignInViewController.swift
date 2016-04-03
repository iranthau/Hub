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
        self.navigationController?.navigationBarHidden = true
        fbSignInButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
                    self.readProfileDataFromFacebook()
                    self.performSegueWithIdentifier("createAccountSegue", sender: nil)
                } else {
                    let currentUser = PFUser.currentUser()
                    self.hubModel.currentUser = User(parseUser: currentUser!)
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func readProfileDataFromFacebook() {
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
    
        userDetails.startWithCompletionHandler {(connection, result, error: NSError!) -> Void in
            if(error != nil) {
                let errorMessage = error.localizedDescription
                self.showAlert(errorMessage)
            } else if(result != nil) {
                let fName = result["first_name"]! as! String
                let lName = result["last_name"]! as! String
                let email = result["email"]! as! String
                
                let parseUser = PFUser()
                let user = User(parseUser: parseUser)
                user.setUpParseUser(email, fName: fName, lName: lName)
                self.hubModel.currentUser = user
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    user.setProfileImage(self.readProfileImageFromFacebook(result["id"]! as! String))
                    self.uploadUserDetailsToParse(user)
                }
            }
        }
    }
    
    func uploadUserDetailsToParse(user: User) {
        let pfUser = user.matchingParseObject
        pfUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if(success) {
                print("User details uploaded")
            }
        })
    }
    
    func readProfileImageFromFacebook(userID: String) -> UIImage {
        let userProfileUrl = "https://graph.facebook.com/\(userID)/picture?type=large"
        let profilePictureUrl = NSURL(string: userProfileUrl)!
        let profilePicturedata = NSData(contentsOfURL: profilePictureUrl)!
        return UIImage(data: profilePicturedata)!
    }
}

