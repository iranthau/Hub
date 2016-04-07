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
//        self.navigationController?.navigationBarHidden = true
        let user = hubModel.currentUser
                
        profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
        profileImage.clipsToBounds = true
        
        let imageFile = user!.profileImage
        imageFile!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.profileImage.image = UIImage(data:imageData)
                }
            }
        }
        
        firstNameLabel.text = user!.firstName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
