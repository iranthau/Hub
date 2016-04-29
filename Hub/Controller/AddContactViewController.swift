//  AddContactController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 18/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class AddContactViewController: UIViewController, ContactShareCellDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactSelectionTableView: UITableView!
    @IBOutlet weak var howToContactLabel: UILabel!
    
    var contactProfile: User?
    var contacts = [Contact]()
    var requestedContacts = [PFObject]()
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let pushQuery = PFInstallation.query()!
        let friend = contactProfile!.matchingParseObject
        pushQuery.whereKey("user", equalTo: friend)
        
        // Send the push notification created above
        let push = PFPush()
        push.setQuery(pushQuery)
        let message = "You have a request from \(contactProfile!.firstName!) \(contactProfile!.lastName!)"
        let data = [
            "alert": message,
            "badge": "Increment",
            "sound": "Ambient Hit.mp3"
        ]
        push.setData(data)
        
        let parseObject = PFObject(className: "SharedPermission")
        let sharedPermission = SharedPermission(parseObject: parseObject)
        let currentUser = hubModel.currentUser?.matchingParseObject
        sharedPermission.buildParseObject(friend, toUser: currentUser!, contacts: requestedContacts, status: "pending")
        sharedPermission.matchingParseObject.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                push.sendPushInBackground()
            }
        }
    }
}

extension AddContactViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AddProfileContactCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath) as! AddContactCell
        let contact = contacts[indexPath.row]
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: contact.getImageName())
        
        let label = cell.viewWithTag(2) as! UILabel
        if contact.type! == ContactType.Social.label {
            label.text = "\(contact.subType!)"
        } else {
            label.text = "\(contact.subType!) \(contact.type!)"
        }
        
        if let sharedSwitch = cell.viewWithTag(3) as? UISwitch {
            sharedSwitch.setOn(contact.selected!, animated: true)
        }
        
        cell.cellDelegate = self
        return cell
    }
}

extension AddContactViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}