//
//  SharedPermission.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 3/04/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class SharedPermission {
    let parseClassName = "SharedPermission"
    let matchingParseObject: PFObject
    var objectId: String?
    var user: User?
    var userFriend: User?
    var status: Bool?
    
    init(parseObject: PFObject) {
        matchingParseObject = parseObject
    }
    
    func buildSharedPermission() {
        objectId = matchingParseObject.objectId
        
        let parseFromUser = matchingParseObject["user"] as! PFUser
        let fromUser = User(parseUser: parseFromUser)
        fromUser.buildUser()
        user = fromUser
        
        let parseToUser = matchingParseObject["userFriend"] as! PFUser
        let toUser = User(parseUser: parseToUser)
        toUser.buildUser()
        userFriend = toUser
        status = matchingParseObject["status"] as? Bool
    }
    
    func buildParseObject(fromUser: PFUser, toUser: PFUser, contacts: [PFObject], status: String) {
        matchingParseObject["user"] = fromUser
        matchingParseObject["userFriend"] = toUser
        matchingParseObject["contacts"] = contacts
        matchingParseObject["status"] = status
    }
    
    func setContacts(contacts: [PFObject]) {
        matchingParseObject["contacts"] = contacts
    }
    
    func getContacts(me: User, friend: User, contactRequestTVC: ContactRequestTableViewController) {
        let query = PFQuery(className: parseClassName)
        query.whereKey("userFriend", equalTo: friend.matchingParseObject)
        query.whereKey("user", equalTo: me.matchingParseObject)
        
        query.getFirstObjectInBackgroundWithBlock {
            (sharedPermission: PFObject?, error: NSError?) -> Void in
            
            if let sharedPermission = sharedPermission {
                let contacts = sharedPermission.objectForKey("contacts") as! [PFObject]
                
                for contact in contacts {
                    contact.fetchInBackgroundWithBlock {
                        (fetchedContact: PFObject?, error: NSError?) -> Void in
                        let sharedContact = Contact(parseObject: fetchedContact!)
                        sharedContact.buildContact()
                        contactRequestTVC.contacts.append(sharedContact)
                        contactRequestTVC.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func saveInParse(pushNotification: PFPush) {
        matchingParseObject.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                pushNotification.sendPushInBackground()
            }
        }
    }
}