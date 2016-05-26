//  ContactRequestTableViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 16/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class ConfigureSharedContactTVC: UITableViewController, ContactShareCellDelegate {
    
    var friend: User?
    var currentUser: User?
    var contacts = [Contact]()
    var sharedContacts = [Contact]()
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friend!.firstName
        currentUser = hubModel.currentUser
        self.tableView.separatorColor = ViewFactory.hidden()
        
        if let currentUser = currentUser {
            currentUser.getContacts {
                (contacts, error) in
                if let error = error {
                    print(error)
                } else if let contacts = contacts {
                    for a in contacts {
                        for b in self.sharedContacts {
                            if b.objectId == a.objectId {
                                a.selected = true
                            }
                        }
                    }
                    self.contacts = contacts
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactTypeCell", forIndexPath: indexPath) as! ContactShareCell
        let contact = contacts[indexPath.row]
        let contactLabel = cell.viewWithTag(1) as! UILabel
        let contactImage = cell.viewWithTag(2) as! UIImageView
        let sharedSwitch = cell.viewWithTag(3) as! UISwitch
        
        contactLabel.text = contact.value!
        sharedSwitch.setOn(contact.selected!, animated: true)
        contactImage.image = UIImage(named: contact.getImageName())
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return "Select what \(friend!.firstName) can see"
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirm(sender: UIBarButtonItem) {
        if let friend = friend {
            let pushQuery = HubUtility.configurePushInstallation(friend)
            if let currentUser = currentUser {
                let message = "\(currentUser.firstName) \(currentUser.lastName) has updated his shared contacts"
                let pushNotification = HubUtility.configurePushNotification(pushQuery, message: message)
                let sharedPermission = SharedPermission(fromUser: currentUser, toUser: friend, contacts: sharedContacts, status: "")
                sharedPermission.updateSharedContacts(pushNotification, completion: {
                    (success, error) in
                    if let error = error {
                        print(error)
                    } else if success {
                        self.back(sender)
                    }
                })
            }
        }
    }
    
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Add contact", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    //-----------------Contact Share Cell Delegate Method--------------------
    func switchStateChanged(sender: AnyObject, isOn: Bool) {
        let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
        let contact = contacts[indexPath!.row]
        contact.selected = isOn
        addContactToArray(contact)
    }
    
    func addContactToArray(contact: Contact) {
        if contact.selected! {
            sharedContacts.append(contact)
        } else {
            sharedContacts.removeObject(contact)
        }
    }
}

//Array extension so that an object can be removed from an array
extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    func removeDuplicates() -> [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}