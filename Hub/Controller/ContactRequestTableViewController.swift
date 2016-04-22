//  ContactRequestTableViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 16/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class ContactRequestTableViewController: UITableViewController, ContactShareCellDelegate {
    
    var friend: User?
    var currentUser: User?
    var contacts = [Contact]()
    var acceptedContacts = [PFObject]()
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friend!.firstName!
        currentUser = hubModel.currentUser
        ViewFactory.hideTableViewSeparator(self.tableView)
        
        if let currentUser = currentUser {
            currentUser.getRequestedContacts(friend!, contactRequestTVC: self)
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
        return "Select what \(friend!.firstName!) can see"
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        navigateBack()
    }
    
    @IBAction func acceptRequest(sender: UIBarButtonItem) {
        if let friend = friend {
            let friendParseObject = friend.matchingParseObject
            let myParseObject = currentUser!.matchingParseObject
            let pushQuery = HubUtility.configurePushInstallation(friendParseObject, currentUser: myParseObject)
            let message = "\(friend.firstName!) \(friend.lastName!) accepted your request to connect"
            let pushNotification = HubUtility.configurePushNotification(pushQuery, message: message)
            currentUser!.acceptRequest(friendParseObject, push: pushNotification, viewController: self)
        }
    }
    
    func navigateBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //-----------------Contact Share Cell Delegate Method--------------------
    func switchStateChanged(sender: AnyObject, isOn: Bool) {
        let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
        let contact = contacts[indexPath!.row]
        contact.selected = isOn
        acceptedContacts.append(contact.matchingParseObject)
    }
}

//Array extension so that an object can be removed from an array
extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
