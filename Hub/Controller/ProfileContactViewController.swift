//  ProfileContactViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 12/03/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class ProfileContactViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var SelectedButtonColorView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var contactHoursTextView: UITextView!
    @IBOutlet weak var sharedContactsTableView: UITableView!
    @IBOutlet weak var mySharedContactsTableView: UITableView!
    
    var contactProfile: User?
    var currentUser: User?
    var mySharedContacts = [Contact]()
    var activeDataSource = [Contact]()
    var sharedPhoneContacts = [Contact]()
    var sharedEmailContacts = [Contact]()
    var sharedAddressContacts = [Contact]()
    var sharedSocialContacts = [Contact]()
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = hubModel.currentUser
        sharedContactsTableView.separatorColor = ViewFactory.hidden()
        mySharedContactsTableView.separatorColor = ViewFactory.hidden()
        ViewFactory.circularImage(profileImageView)
        SelectedButtonColorView.backgroundColor = ViewFactory.backGroundColor(ContactType.Phone)
        activeDataSource = sharedPhoneContacts
        scrollView.contentSize.height = 826
        
        if let contactProfile = contactProfile {
            title = "\(contactProfile.firstName) \(contactProfile.lastName)"
            contactProfile.getProfileImage { (image) in
                self.profileImageView.image = image
            }
            ViewFactory.setLabelPlaceholder("nickname", text: contactProfile.nickname, label: nickNameLabel)
            ViewFactory.setLabelPlaceholder("city", text: contactProfile.city, label: cityLabel)
            ViewFactory.setTextViewPlaceholder("No prefered time provided", text: contactProfile.availableTime, textView: contactHoursTextView)
        }
        
        if let currentUser = currentUser {
            currentUser.getAllSharedContacts(contactProfile, completion: {
                (contacts, error) in
                if let error = error {
                    print(error)
                } else if let contacts = contacts {
                    for sharedContact in contacts {
                        switch sharedContact.type! {
                        case ContactType.Phone.label:
                            self.sharedPhoneContacts.append(sharedContact)
                        case ContactType.Email.label:
                            self.sharedEmailContacts.append(sharedContact)
                        case ContactType.Address.label:
                            self.sharedAddressContacts.append(sharedContact)
                        case ContactType.Social.label:
                            self.sharedSocialContacts.append(sharedContact)
                        default:
                            return
                        }
                    }
                }
                self.refreshTableView()
            })
            
            currentUser.getContactsIShared(contactProfile, completion: {
                (contacts, error) in
                if let error = error {
                    print(error)
                } else if let contacts = contacts {
                    self.mySharedContacts.removeAll()
                    for sharedContact in contacts {
                        self.mySharedContacts.append(sharedContact)
                    }
                }
                self.mySharedContactsTableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let currentUser = currentUser {
            currentUser.getContactsIShared(contactProfile, completion: {
                (contacts, error) in
                if let error = error {
                    print(error)
                } else if let contacts = contacts {
                    self.mySharedContacts.removeAll()
                    for sharedContact in contacts {
                        self.mySharedContacts.append(sharedContact)
                    }
                }
                self.mySharedContactsTableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func phoneButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = ViewFactory.backGroundColor(ContactType.Phone)
        activeDataSource = sharedPhoneContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func emailButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = ViewFactory.backGroundColor(ContactType.Email)
        activeDataSource = sharedEmailContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func addressButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = ViewFactory.backGroundColor(ContactType.Address)
        activeDataSource = sharedAddressContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func socialButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = ViewFactory.backGroundColor(ContactType.Social)
        activeDataSource = sharedSocialContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func configureSharedContacts(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("configureSharedContactsSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "configureSharedContactsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            if let destinationVC = navigationController.topViewController as? ConfigureSharedContactTVC {
                destinationVC.friend = self.contactProfile
                destinationVC.sharedContacts = self.mySharedContacts
            }
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //-----------------------Methods for table view---------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mySharedContactsTableView {
            return mySharedContacts.count
        }
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.mySharedContactsTableView {
            return "\(contactProfile!.firstName) can see"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactItemCell", forIndexPath: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        let icon = cell.viewWithTag(2) as! UIImageView
        
        if tableView == self.mySharedContactsTableView {
            let contact = mySharedContacts[indexPath.row]
            setUpContactCell(label, icon: icon, contact: contact)
        } else {
            let contact = activeDataSource[indexPath.row]
            setUpContactCell(label, icon: icon, contact: contact)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshTableView() {
        activeDataSource = sharedPhoneContacts
        sharedContactsTableView.reloadData()
    }
    
    //-------------------------Private Methods------------------------
    private func setUpContactCell(label: UILabel, icon: UIImageView, contact: Contact) {
        label.text = contact.value
        icon.image = UIImage(named: contact.getImageName())
    }
}
