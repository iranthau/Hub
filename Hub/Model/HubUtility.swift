//  HubUtility.swift
//  Hub
//  Created by Irantha Rajakaruna on 20/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit
import Parse

class HubUtility {
    class func convertImageFileToParseFile(imageFile: UIImage) -> PFFile {
        let imageData = imageFile.lowQualityJPEGNSData
        return PFFile(data: imageData)!
    }
    
    /* Create and return a parse push notification object when given
     * the query and the message to send. The sound and badge configurations
     * are set to following configs by default. */
    class func configurePushNotification(query: PFQuery, message: String) -> PFPush {
        let push = PFPush()
        push.setQuery(query)
        let data = [ "alert": message, "badge": "Increment", "sound": "Ambient Hit.mp3" ]
        push.setData(data)
        return push
    }
    
    /* Create a parse push query when given the from user and the to user parse 
     * objects. The query is configured to query shared permission class by default.
     */
    class func configurePushInstallation(pObject: PFUser, currentUser: PFUser) -> PFQuery {
        let pushQuery = PFInstallation.query()!
        pushQuery.whereKey("userFriend", equalTo: pObject)
        pushQuery.whereKey("user", equalTo: currentUser)
        return pushQuery
    }
    
    class func initialisePhoneContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 1...4 {
            let contact = buildInitialContactForCell(index, type: ContactType.Phone)
            contacts.append(contact)
        }
        return contacts
    }
    
    class func initialiseEmailContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 5...8 {
            let contact = buildInitialContactForCell(index, type: ContactType.Email)
            contacts.append(contact)
        }
        return contacts
    }
    
    class func initialiseAddressContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 9...12 {
            let contact = buildInitialContactForCell(index, type: ContactType.Address)
            contacts.append(contact)
        }
        return contacts
    }
    
    class func initialiseSocialContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 13...23 {
            let contact = buildInitialContactForCell(index, type: ContactType.Social)
            contacts.append(contact)
        }
        return contacts
    }
    
    class func buildInitialContactForCell(index: Int, type: ContactType) -> Contact {
        let parseObject = PFObject(className: "Contact")
        let contact = Contact(parseObject: parseObject)
        contact.type = type.label
        contact.subType = ContactSubType(rawValue: index)!.label
        return contact
    }
}