//  ContactRequestTableViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 16/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class ContactRequestTableViewController: UITableViewController, ContactShareCellDelegate {
    
    var requestContact: User?
    var currentUser: User?
    var viewController: RequestsTableViewController?
    var contacts = [Contact]()
    var acceptedContacts = [PFObject]()
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = requestContact!.firstName!
        currentUser = hubModel.currentUser
        ViewFactory.hideTableViewSeparator(self.tableView)
        
        if let currentUser = currentUser {
            currentUser.getRequestedContacts(requestContact!, contactRequestTVC: self)
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
        return "Select what \(requestContact!.firstName!) can see"
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func acceptRequest(sender: UIBarButtonItem) {
        viewController!.requests.removeObject(requestContact!)
        viewController!.tableView.reloadData()
        
        let pushQuery = PFInstallation.query()!
        let friend = requestContact!.matchingParseObject
        pushQuery.whereKey("userFriend", equalTo: friend)
        pushQuery.whereKey("user", equalTo: currentUser!.matchingParseObject)
        
        let push = PFPush()
        push.setQuery(pushQuery)
        let message = "\(requestContact!.firstName!) \(requestContact!.lastName!) accepted your request to connect"
        let data = [
            "alert": message,
            "badge": "Increment",
            "sound": "Ambient Hit.mp3"
        ]
        push.setData(data)
        
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: currentUser!.matchingParseObject)
        query.whereKey("userFriend", equalTo: friend)

        query.getFirstObjectInBackgroundWithBlock {
            (sharedPermission: PFObject?, error: NSError?) in
            if let sharedPermission = sharedPermission {
                sharedPermission["contacts"] = self.acceptedContacts
                sharedPermission["status"] = "accepted"
                sharedPermission.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) in
                    if success {
                        push.sendPushInBackground()
                    }
                }
            }
        }
        back(sender)
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
