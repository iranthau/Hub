//  TermsConditionsViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 16/12/2015.
//  Copyright © 2015 88Software. All rights reserved.

import UIKit
import Parse

class TermsConditionsViewController: UIViewController {

    @IBOutlet weak var agreeToTermsButton: UIBarButtonItem!

    var agreeIsEnabled:Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agreeToTermsButton.enabled = agreeIsEnabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func agreedToTerms() {
        let currentUser = PFUser.currentUser()
        if currentUser?.isNew == true {
            self.performSegueWithIdentifier("facebookSignUpSegue", sender: nil)
        } else {
            self.performSegueWithIdentifier("normalSignUpSegue", sender: nil)
        }
    }
    
    @IBAction func cancelAndReturnHome() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
