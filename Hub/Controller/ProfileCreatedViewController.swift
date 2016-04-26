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
        let user = hubModel.currentUser!
        user.buildUser()
        
        let parseEmailObject = PFObject(className: "Contact")
        let emailContact = Contact(parseObject: parseEmailObject)
        emailContact.value = user.email!
        emailContact.type = "email"
        emailContact.subType = "home"
        user.setContacts([emailContact])
        
        ViewFactory.makeImageViewRound(profileImage)
        user.getProfileImage(profileImage)
        firstNameLabel.text = user.firstName!
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
