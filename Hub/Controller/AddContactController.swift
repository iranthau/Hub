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
    
    var contactProfile: User?
    var userData: MyProfileTestData?
    var contacts:[String] = Array()
    
//    var sharedContacts:[Contact]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(contactProfile!.firstName)" + " " + "\(contactProfile!.lastName)"
        
        //hide table view separator
        contactSelectionTableView.separatorColor = UIColor(red: 255/255.0,
                                                           green: 255/255.0, blue: 255/255.0, alpha: 0.0)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.profileImageView.image = self.contactProfile!.getProfileImage()
        }
        
        //set profile image to circular shape
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        //set "how to connect" label:
        howToContactLabel.text = "How would you like to connect with \(contactProfile!.firstName)?"
        
        if let user = userData {
            //set screen title
            
            //temporary code to populate the Contacts array, rework to use a Contact class
            for item in user.phoneNumberTestData {
                contacts.append(item)
            }
            
            for item in user.emailTestData {
                contacts.append(item)
            }
            
            for item in user.addressTestData {
                contacts.append(item)
            }
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

extension AddContactController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "AddProfileContactListCell"
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                forIndexPath: indexPath) as! AddContactTableViewCell
            
//            let label = cell.viewWithTag(88) as! UILabel
//            label.text = activeDataSource[indexPath.row]
//            print("***Text in label:" + label.text!)
//            
//            let imageView = cell.viewWithTag(87) as! UIImageView
//            imageView.image = activeContactImage
            
            
            return cell

    }
}

extension AddContactController: UITableViewDelegate {
    
}