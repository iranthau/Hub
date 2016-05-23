//  AddContactController.swift
//  Hub
//  Created by Alexei Gudimenko on 18/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class AddContactViewController: BaseViewController, ContactShareCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactSelectionTableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendRequestButton: UIBarButtonItem!
    
    var contactProfile: User?
    var currentUser: User?
    var contacts = [Contact]()
    var requestedContacts = [Contact]()
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = hubModel.currentUser
        ViewFactory.hideTableViewSeparator(contactSelectionTableView)
        ViewFactory.makeImageViewRound(profileImageView)
        
        if let friend = contactProfile {
            title = "\(friend.firstName) \(friend.lastName)"
            friend.getProfileImage {
                (image) in
                self.profileImageView.image = image
            }
            if let user = currentUser {
                user.getContacts {
                    (contacts, error) in
                    if let error = error {
                        print(error)
                    } else if let contacts = contacts {
                        self.contacts = contacts
                        self.contactSelectionTableView.reloadData()
                    }
                }
            }
            
            ViewFactory.setLabelPlaceholder("nickname", text: friend.nickname, label: nicknameLabel)
            ViewFactory.setLabelPlaceholder("city", text: friend.city, label: locationLabel)
            if friend.hasContactsToShar() {
                textView.text = "What contact details would you like to share with \(friend.firstName)?"
            } else {
                textView.text = "\(friend.firstName) has not shared any details"
            }
        }
        disableSendRequestButton()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func switchStateChanged(sender: AnyObject, isOn: Bool) {
        let indexPath = contactSelectionTableView.indexPathForCell(sender as! UITableViewCell)
        let contact = contacts[indexPath!.row]
        contact.selected = isOn
        addContactToArray(contact)
        disableSendRequestButton()
    }
    
    @IBAction func sendRequest(sender: UIBarButtonItem) {
        let pushQuery = HubUtility.configurePushInstallation(contactProfile)
        let parseObject = PFObject(className: "SharedPermission")
        let sharedPermission = SharedPermission(parseObject: parseObject)
        if let currentUser = currentUser {
            let message = "You have a request from \(currentUser.firstName) \(currentUser.lastName)"
            let pushNotification = HubUtility.configurePushNotification(pushQuery, message: message)
            sharedPermission.buildParseObject(currentUser, toUser: contactProfile, contacts: requestedContacts, status: "pending")
            sharedPermission.sendRequest(pushNotification, completion: {
                (success, error) in
                self.showAlert("Request is sent")
                self.back(sender)
            })
        }
    }
    
    //Table view methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddProfileContactCell", forIndexPath: indexPath) as! AddContactCell
        let contact = contacts[indexPath.row]
        let imageView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        let sharedSwitch = cell.viewWithTag(3) as! UISwitch
        
        cell.cellDelegate = self
        imageView.image = UIImage(named: contact.getImageName())
        sharedSwitch.setOn(contact.selected!, animated: true)
        label.text = contact.value!
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func showAlert(message: String) {
        let alertError = UIAlertController(title: "Add contact", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    override func disableUIBarbutton() {
        sendRequestButton.enabled = false
    }
    
    //---------------------------Private methods------------------
    private func disableSendRequestButton() {
        if requestedContacts.isEmpty {
            sendRequestButton.enabled = false
        } else {
            sendRequestButton.enabled = true
        }
    }
    
    func addContactToArray(contact: Contact) {
        if contact.selected! {
            requestedContacts.append(contact)
        } else {
            requestedContacts.removeObject(contact)
        }
    }
}