//  ProfileCreatedViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 6/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class ProfileCreatedViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!

    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = hubModel.currentUser
        if let user = user {
            firstNameLabel.text = user.firstName
            let emailContact = Contact(value: user.email!, type: "email", subType: "home")
            user.setContacts([emailContact]) {
                (success: Bool, error: String?) in
                if success {
                    print("Email saved")
                }
            }
            user.getProfileImage { (image) in
                self.profileImage.image = image
            }
        }
        
        ViewFactory.makeImageViewRound(profileImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createProfile() {
        let heyyaTabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("HeyyaTabBarController") as! UITabBarController
        heyyaTabBarController.selectedIndex = 1
        self.presentViewController(heyyaTabBarController, animated: true, completion: nil)
    }
}
