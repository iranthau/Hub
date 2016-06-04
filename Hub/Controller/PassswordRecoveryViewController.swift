//  PassswordRecoveryViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 2/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class PassswordRecoveryViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  let hubModel = HubModel.sharedInstance
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func recoverPassword(sender: AnyObject) {
    let email = emailTextField.text
    
    User.resetPassword(email, completion: {
      (success, error) in
      if let error = error {
        self.showAlert(error)
      } else if success {
        self.showAlert("Email sent to \(email)")
      }
    })
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //TODO:Can move to somewhere else (common place)
  func showAlert(message: String) {
    let alertError = UIAlertController(title: "Recover password", message: message, preferredStyle: .Alert)
    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertError.addAction(defaultAction)
    self.presentViewController(alertError, animated: true, completion: nil)
  }
}
