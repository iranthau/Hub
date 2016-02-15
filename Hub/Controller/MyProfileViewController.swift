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
    @IBOutlet weak var selectedContactLabel: UILabel!

    
    // #warning: this object is simply a test object to enable functionality 
    //  testing. Replace this with correct content from the model when the 
    //  relevant bits of functionality are merged. (Subject to pull request) - A. G.
    let userData = MyProfileTestData()
    
    var activeDataSource:[String] = []
    var activeContactImage:UIImage = UIImage()
    var keyboardState = 0
    
    let defaultPhoneImage = UIImage(named: "phone")
    let defaultEmailImage = UIImage(named: "email-other")
    let defaultAddressImage = UIImage(named: "address-other")
    let defaultSocialImage = UIImage(named: "social-other")

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        // Do any additional setup after loading the view.
        // TODO: replace test values with content from model
        title = userData.userFirstName + " " + userData.userLastName
        
        // Make image view circular and set it to image from model:
        profileImageView.image = userData.userImage
//        profileImageView.image = UIImage(named: userData.userImageName)
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        selectedContactLabel.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
            blue: 27/255.0, alpha: 0.4)
        
        // Set user info to display on loading:
        nicknameLabel.text = "☞ " + userData.userNickname
        cityLocationLabel.text = "📍 " + userData.userCity
        contactHoursDetail.text = userData.userAvailability
        
        // Display phone numbers by default:
        activeDataSource = userData.phoneNumberTestData
        activeContactImage = defaultPhoneImage!
        keyboardState = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneButtonPressed() {
        activeDataSource = userData.phoneNumberTestData
        selectedContactLabel.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
            blue: 27/255.0, alpha: 0.4)
        activeContactImage = defaultPhoneImage!
        keyboardState = 1
        print("***Phone button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        activeDataSource = userData.emailTestData
        selectedContactLabel.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0,
            blue: 51/255.0, alpha: 0.4)
        activeContactImage = defaultEmailImage!
        keyboardState = 2
        print("***Email button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        activeDataSource = userData.addressTestData
        selectedContactLabel.backgroundColor = UIColor(red: 212/255.0, green: 149/255.0,
            blue: 225/255.0, alpha: 0.4)
        activeContactImage = defaultAddressImage!
        keyboardState = 3
        print("***Address button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        activeDataSource = userData.socialTestData
        selectedContactLabel.backgroundColor = UIColor(red: 138/255.0, green: 194/255.0,
            blue: 81/255.0, alpha: 0.4)
        activeContactImage = defaultSocialImage!
        keyboardState = 4
        print("***Social button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditProfileSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditMyProfileViewController
            
            controller.doneIsEnabled = false
            // #warning: replace with model data!
            controller.userData = userData
            controller.activeDataSource = activeDataSource
            controller.keyboardForContactType = keyboardState
            controller.activeContactImage = activeContactImage
            
            controller.delegate = self
        }
    }
    

}

/*
 UITableView Data Source and Delegate methods. The table view is used to display a list of user's contact
  points of a given type (e.g. phone, email, etc. ). Which type is displayed is determined by whichever
  button is pressed on the UI. There are four buttons, one for each type of contact; tapping each one will
  set which data source the table view will use.
*/

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
            label.text = activeDataSource[indexPath.row]
            print("***Text in label:" + label.text!)
            
            let imageView = cell.viewWithTag(87) as! UIImageView
            imageView.image = activeContactImage
            
            
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
        print("***delegate: editMyProfileViewControllerDidCancel")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editMyProfileViewController(controller: EditMyProfileViewController,
        didFinishEditingProfile userProfile: MyProfileTestData) {
            print("***delegate: didFinishEditingProfile")
            
            userData.userFirstName = userProfile.userFirstName
            userData.userLastName = userProfile.userLastName
            userData.userNickname = userProfile.userNickname
            userData.userAvailability = userProfile.userAvailability
            userData.userImage = userProfile.userImage
            profileImageView.image = userData.userImage
            
            title = userData.userFirstName + " " + userData.userLastName
            
            tableView.reloadData()
            
            
            print("***first name after delegate: \(userData.userFirstName)")
        dismissViewControllerAnimated(true, completion: nil)
    }
}