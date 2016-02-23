//
//  AddContactController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 18/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class AddContactController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var contactSelectionTableView: UITableView!
    @IBOutlet weak var howToContactLabel: UILabel!
    
   
    //var userData: MyProfileTestData?
    var userData:MyProfileTestData? = MyProfileTestData()
    var sharedContacts:[Contact]
    
    override func viewDidLoad() {
        
        if let user = userData {
            //set screen title
            title = "\(user.userFirstName)" + " " + "\(user.userLastName)"
            
            //hide table view separator
            contactSelectionTableView.separatorColor = UIColor(red: 255/255.0,
                green: 255/255.0, blue: 255/255.0, alpha: 0.0)
            
            //set profile image to circular shape
            profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
            profileImageView.clipsToBounds = true
            
            //set "how to connect" label:
            howToContactLabel.text = "How would you like to connect with \(user.userFirstName)?"
            
            //set profile information:
            
            
        }
        
        super.viewDidLoad()
    }
}

extension AddContactController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            return UITableViewCell()
    }
}

extension AddContactController: UITableViewDelegate {
    
}