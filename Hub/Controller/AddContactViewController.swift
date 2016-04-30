//  AddContactController.swift
//  Hub
//  Created by Alexei Gudimenko on 18/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class AddContactViewController: UIViewController, ContactShareCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactSelectionTableView: UITableView!
    @IBOutlet weak var howToContactLabel: UILabel!
    
    var contactProfile: User?
    var currentUser: User?
    var contacts = [Contact]()
    var requestedContacts = [PFObject]()
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = hubModel.currentUser
        ViewFactory.hideTableViewSeparator(contactSelectionTableView)
        ViewFactory.makeImageViewRound(profileImageView)
        
        if let friend = contactProfile {
            title = "\(friend.firstName!) \(friend.lastName!)"
            friend.getProfileImage(profileImageView)
            friend.getAvailableContacts(self)
            ViewFactory.setLabelPlaceholder("nickname", text: friend.nickname, label: nicknameLabel)
            ViewFactory.setLabelPlaceholder("city", text: friend.city, label: locationLabel)
            if friend.hasSharedContacts() {
                howToContactLabel.text = "How would you like to connect with \(friend.firstName!)?"
            } else {
                howToContactLabel.text = "\(friend.firstName!) has not shared any details"
            }
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func switchStateChanged(sender: AnyObject, isOn: Bool) {
        let indexPath = contactSelectionTableView.indexPathForCell(sender as! UITableViewCell)
        let contact = contacts[indexPath!.row]
        contact.selected = isOn
        requestedContacts.append(contact.matchingParseObject)
    }
    
    @IBAction func sendRequest(sender: UIBarButtonItem) {
        let friend = contactProfile!.matchingParseObject
        let pushQuery = HubUtility.configurePushInstallation(friend)
        let parseObject = PFObject(className: "SharedPermission")
        let sharedPermission = SharedPermission(parseObject: parseObject)
        if let currentUser = currentUser {
            let message = "You have a request from \(currentUser.firstName!) \(currentUser.lastName!)"
            let pushNotification = HubUtility.configurePushNotification(pushQuery, message: message)
            sharedPermission.buildParseObject(friend, toUser: currentUser.matchingParseObject, contacts: requestedContacts, status: "pending")
            currentUser.sendRequest(sharedPermission, pushNotification: pushNotification)
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
        label.text = contactDisplayName(contact)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //---------------------------Private methods------------------
    func contactDisplayName(contact: Contact) -> String {
        if contact.type! == ContactType.Social.label {
            return "\(contact.subType!)"
        } else {
            return "\(contact.subType!) \(contact.type!)"
        }
    }
}