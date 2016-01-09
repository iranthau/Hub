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

class TermsConditionsViewController: UIViewController, SetUserHasViewed {

    @IBOutlet weak var agreeToTermsButton: UIBarButtonItem!
    
    //TODO: a toggle function that enables/disables this button based on whether
    // a) userHasViewed flag is true, and b) user has navigated to this from launch
    // or settings screen
    var agreeIsEnabled:Bool = true

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: Read the value of the userHasViewed flag. If true, disable the 'agree'
        // button on startup by greying out or hiding:
        agreeToTermsButton.enabled = agreeIsEnabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //If user agreed to terms and conditions, handle any necessary actions here and
    //proceed to account creation
    @IBAction func agreedToTerms() {
        //set a flag to indicate the user has read this screen and agreed to 
        //terms and conditions - this means the screen won't show up by default next time
        setUserViewedFlag(true)
        
        //TODO: wire up to follow to next screen and add handlers
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //If user did not agree to t&c, handle necessary actions and appropriate prompts
    //here and return to the app home screen
    @IBAction func cancelAndReturnHome() {
        setUserViewedFlag(false)
        //TODO: wire up to return to the home screen and add handlers
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUserViewedFlag(flag: Bool) {
        if flag == true {
            //TODO: set value in the data model and re-use it on next startup
        } else {
            //TODO: set a false value so the T&C screen re-appears on next startup
        }
    }

}
