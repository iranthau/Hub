//
//  ProfileCreatedViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 6/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class ProfileCreatedViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!

    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        let user = hubModel.user
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
        profileImage.clipsToBounds = true
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let image = user!.getProfileImage()

            dispatch_async(dispatch_get_main_queue()) {
                self.profileImage.image = image
            }
        }
        
        firstNameLabel.text = user!.firstName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
