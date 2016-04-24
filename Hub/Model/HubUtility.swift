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
    
    /* Build an array of phone contacts where each contact has empty value. Used
     * to initialise the table views in edit my profile view controller */
    class func initialisePhoneContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 1...4 {
            let contact = buildInitialContactForCell(index, type: ContactType.Phone)
            contacts.append(contact)
        }
        return contacts
    }
    
    /* Build an array of email contacts for the same purpose as initialisePhoneContacts */
    class func initialiseEmailContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 5...8 {
            let contact = buildInitialContactForCell(index, type: ContactType.Email)
            contacts.append(contact)
        }
        return contacts
    }
    
    /* Build an array of address contacts for the same purpose as initialisePhoneContacts */
    class func initialiseAddressContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 9...12 {
            let contact = buildInitialContactForCell(index, type: ContactType.Address)
            contacts.append(contact)
        }
        return contacts
    }
    
    /* Build an array of social contacts for the same purpose as initialisePhoneContacts */
    class func initialiseSocialContacts() -> [Contact] {
        var contacts = [Contact]()
        for index in 13...23 {
            let contact = buildInitialContactForCell(index, type: ContactType.Social)
            contacts.append(contact)
        }
        return contacts
    }
    
    /* Set the value of a contact when another contact with the value is given */
    class func putContactsInAppropriateTextfield(contactToMatch: Contact, contacts: [Contact]) {
        for contact in contacts {
            if contact.subType == contactToMatch.subType {
                contact.objectId = contactToMatch.objectId
                contact.value = contactToMatch.value
            }
        }
    }
    
    /* Combines few arrays when given an array of arrays */
    class func appendContactsArrays(arrays: [[Contact]]) -> [Contact] {
        var contactsArray = [Contact]()
        for array in arrays {
            contactsArray += array
        }
        return contactsArray
    }
    
    /* Filter contacts if they didn't exist before and their value is empty */
    class func filterContacts(editedContacts: [Contact]) -> [Contact] {
        var contactsToSave = [Contact]()
        for contact in editedContacts {
            if contact.objectId != nil || contact.value != nil {
                contactsToSave.append(contact)
            }
        }
        return contactsToSave
    }
    
    //-------------------Private Methods---------------------------
    
    /* Builds a contact with empty value when contact type and the row value of
     * sub type is provided. */
    class func buildInitialContactForCell(index: Int, type: ContactType) -> Contact {
        let parseObject = PFObject(className: "Contact")
        let contact = Contact(parseObject: parseObject)
        contact.type = type.label
        contact.subType = ContactSubType(rawValue: index)!.label
        return contact
    }
}