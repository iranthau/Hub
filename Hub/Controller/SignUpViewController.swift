//
//  SignUpViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fNameTextfield: UITextField!
    @IBOutlet weak var lNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var cPasswordTextfield: UITextField!
    
    let model = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable back button
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signMeUp(sender: AnyObject) {
        let firstName   = fNameTextfield.text!
        let lastName    = lNameTextfield.text!
        let email       = emailTextfield.text!
        let password    = passwordTextfield.text!
        let password_2  = cPasswordTextfield.text!
        
        if password == password_2 {
            let user = User(firstName: firstName, lastName: lastName, email: email, password: password)
            model.userSignUp(user)
        } else {
            print("Password doesn't match")
        }
    }
}