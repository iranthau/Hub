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
    contactSelectionTableView.separatorColor = ViewFactory.hidden()
    ViewFactory.circularImage(profileImageView)
    
    if let friend = contactProfile {
      title = "\(friend.firstName) \(friend.lastName)"
      friend.getProfileImage {
        (image) in
        self.profileImageView.image = image
      }
      if let user = currentUser {
        if user.contacts.isEmpty {
          textView.text = "you do not have any contacts to share"
        } else {
          textView.text = "What contact details would you like to share with \(friend.firstName)?"
        }
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
    if let currentUser = currentUser {
      let message = "You have a request from \(currentUser.firstName) \(currentUser.lastName)"
      let pushNotification = HubUtility.configurePushNotification(pushQuery, message: message)
      let sharedPermission = SharedPermission(fromUser: currentUser, toUser: self.contactProfile!, contacts: self.requestedContacts, status: "pending")
      sharedPermission.sendRequest(pushNotification, completion: {
        (success, error) in
        self.showAlert("Request sent to add contact")
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
    sharedSwitch.setOn(contact.selected, animated: true)
    label.text = contact.value!
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func showAlert(message: String) {
    let alertError = UIAlertController(title: "Add contact", message: message, preferredStyle: .Alert)
    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {
      (alert: UIAlertAction) in self.back(alert)
    })
    alertError.addAction(defaultAction)
    self.presentViewController(alertError, animated: true, completion: nil)
  }
  
  func disableUIBarbutton() {
    sendRequestButton.enabled = false
  }
  
  //---------------------------Private methods------------------
  private func disableSendRequestButton() {
    currentUser!.isFriendsWith(contactProfile, completion: { (isFriend) in
      if isFriend {
        self.sendRequestButton.enabled = false
      } else if self.requestedContacts.isEmpty {
        self.sendRequestButton.enabled = false
      } else {
        self.sendRequestButton.enabled = true
      }
    })
  }
  
  func addContactToArray(contact: Contact) {
    if contact.selected{
      requestedContacts.append(contact)
    } else {
      requestedContacts = HubModel.removeObject(requestedContacts, object: contact)
    }
  }
}