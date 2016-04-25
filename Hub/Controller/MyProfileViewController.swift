//  MyProfileViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 7/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditMyProfileDelegate {
    
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
    
    let hubModel = HubModel.sharedInstance
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        user = hubModel.currentUser
        ViewFactory.hideTableViewSeparator(tableView)
        selectedContactView.backgroundColor = ViewFactory.backGroundColor(ContactType.Phone)
        
        if let currentUser = user {
            SetInitialValues(currentUser)
            currentUser.getContacts(self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let currentUser = user {
            SetInitialValues(currentUser)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func phoneButtonPressed() {
        activeDataSource = sharedPhoneContacts
        selectedContactView.backgroundColor = ViewFactory.backGroundColor(ContactType.Phone)
        tableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        activeDataSource = sharedEmailContacts
        selectedContactView.backgroundColor = ViewFactory.backGroundColor(ContactType.Email)
        tableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        activeDataSource = sharedAddressContacts
        selectedContactView.backgroundColor = ViewFactory.backGroundColor(ContactType.Address)
        tableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        activeDataSource = sharedSocialContacts
        selectedContactView.backgroundColor = ViewFactory.backGroundColor(ContactType.Social)
        tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditProfileSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditMyProfileViewController
            controller.delegate = self
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactItemCell", forIndexPath: indexPath) as! ContactItemCell
        let label = cell.viewWithTag(88) as! UILabel
        let imageView = cell.viewWithTag(87) as! UIImageView
        let contact = activeDataSource[indexPath.row]
        
        label.text = activeDataSource[indexPath.row].value
        imageView.image = UIImage(named: contact.getImageName())
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //Delegate method. Called if a user cancel editing
    func editMyProfileViewControllerDidCancel(controller: EditMyProfileViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Delegate method. Called after a user finish editing
    func editMyProfileViewController(controller: EditMyProfileViewController, didFinishEditingProfile userProfile: User) {
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //---------------------Private Methods------------------------
    
    //Set the values of lables and views from a user
    func SetInitialValues(currentUser: User) {
        self.navigationItem.title = "\(currentUser.firstName!) \(currentUser.lastName!)"
        currentUser.getProfileImage(profileImageView)
        ViewFactory.makeImageViewRound(profileImageView)
        ViewFactory.setLabelPlaceholder("nickname", text: currentUser.nickname, label: nicknameLabel)
        ViewFactory.setLabelPlaceholder("city", text: currentUser.city, label: cityLocationLabel)
        ViewFactory.setTextViewPlaceholder("No prefered time provided", text: currentUser.availableTime, textView: contactHoursDetail)
    }
}