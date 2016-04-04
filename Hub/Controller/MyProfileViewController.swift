//
//  MyProfileViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 7/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    //outlet vars:
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var cityLocationLabel: UILabel!
    @IBOutlet weak var contactHoursDetail: UITextView!
    @IBOutlet weak var phoneContactButton: UIButton!
    @IBOutlet weak var emailContactButton: UIButton!
    @IBOutlet weak var addressContactButton: UIButton!
    @IBOutlet weak var socialContactButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedContactView: UIView!
    
    var activeDataSource = [Contact]()
    var sharedPhoneContacts = [Contact]()
    var sharedEmailContacts = [Contact]()
    var sharedAddressContacts = [Contact]()
    var sharedSocialContacts = [Contact]()
    
    var keyboardState = 0
    let hubModel = HubModel.sharedInstance
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        user = hubModel.currentUser
        title = "\(user!.firstName) \(user!.firstName)"
        
        let imageFile = user!.profileImage
        
        imageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.profileImageView.image = UIImage(data:imageData)
                }
            }
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        selectedContactView.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
            blue: 27/255.0, alpha: 1)
        
        // Set user info to display on loading:
        if user!.nickname == nil {
            nicknameLabel.text = "nickname"
            nicknameLabel.textColor = UIColor.lightGrayColor()
        } else {
            nicknameLabel.text = user!.nickname
        }
        
        if user!.city == nil {
            cityLocationLabel.text = "city"
            cityLocationLabel.textColor = UIColor.lightGrayColor()
        } else {
            cityLocationLabel.text = user!.city
        }
        
        if user!.availableTime == nil {
            contactHoursDetail.text = "No prefered time provided"
            contactHoursDetail.textColor = UIColor.lightGrayColor()
        } else {
            contactHoursDetail.text = user!.availableTime
        }
        
        user!.getContacts(self)
        
        keyboardState = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func phoneButtonPressed() {
        activeDataSource = sharedPhoneContacts
        selectedContactView.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
            blue: 27/255.0, alpha: 1)
        keyboardState = 1
        tableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        activeDataSource = sharedEmailContacts
        selectedContactView.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0,
            blue: 51/255.0, alpha: 1)
        keyboardState = 2
        tableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        activeDataSource = sharedAddressContacts
        selectedContactView.backgroundColor = UIColor(red: 212/255.0, green: 149/255.0,
            blue: 225/255.0, alpha: 1)
        keyboardState = 3
        tableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        activeDataSource = sharedSocialContacts
        selectedContactView.backgroundColor = UIColor(red: 138/255.0, green: 194/255.0,
            blue: 81/255.0, alpha: 1)
        keyboardState = 4
        tableView.reloadData()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditProfileSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditMyProfileViewController
            
            controller.doneIsEnabled = false
            // #warning: replace with model data!
//            controller.userData = userData
//            controller.activeDataSource = activeDataSource
//            controller.keyboardForContactType = keyboardState
//            controller.activeContactImage = activeContactImage
            
            controller.delegate = self
        }
    }
    

}

extension MyProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ContactItemCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath) as! ContactItemCell
        let label = cell.viewWithTag(88) as! UILabel
        
        label.text = activeDataSource[indexPath.row].value
        let imageView = cell.viewWithTag(87) as! UIImageView
        imageView.image = UIImage(named: activeDataSource[indexPath.row].getImageName())
        
        return cell
    }
}

extension MyProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
}

extension MyProfileViewController: EditMyProfileViewControllerDelegate {
    
    func editMyProfileViewControllerDidCancel(controller: EditMyProfileViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editMyProfileViewController(controller: EditMyProfileViewController,
        didFinishEditingProfile userProfile: MyProfileTestData) {
//            userData.userFirstName = userProfile.userFirstName
//            userData.userLastName = userProfile.userLastName
//            userData.userNickname = userProfile.userNickname
//            userData.userAvailability = userProfile.userAvailability
//            userData.userImage = userProfile.userImage
//            profileImageView.image = userData.userImage
        
//            title = userData.userFirstName + " " + userData.userLastName
        
            tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}