//
//  TermsConditionsViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 16/12/2015.
//  Copyright © 2015 88Software. All rights reserved.
//
//  Any functionality relating to the terms and conditions screen goes here.
//

import UIKit

class TermsConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //If user agreed to terms and conditions, handle any necessary actions here and
    //proceed to account creation
    @IBAction func agreedToTerms() {
        
    }
    
    //If user did not agree to t&c, handle necessary actions and appropriate prompts
    //here and return to the app home screen
    @IBAction func cancelAndReturnHome() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
