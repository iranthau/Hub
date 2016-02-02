//
//  PassswordRecoveryViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 2/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit
import Parse

class PassswordRecoveryViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recoverPassword(sender: AnyObject) {
        let email = emailTextField.text!

        PFUser.requestPasswordResetForEmailInBackground(email) {
            (success: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                self.showAlert(errorMessage!)
            } else {
                self.showAlert("Email sent to \(email)")
            }
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Recover password", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        
        self.presentViewController(alertError, animated: true, completion: nil)
    }
}
