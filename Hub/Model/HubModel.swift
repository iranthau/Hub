//  HubModel.swift
//  Hub
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit
import Parse
import ParseFacebookUtilsV4

class HubModel {
    
    var currentUser: User?
    
    private init() {
        
    }
    
    private struct Static {
        static var instance: HubModel?
    }
    
    class var sharedInstance: HubModel {
        if !(Static.instance != nil) {
            Static.instance = HubModel()
        }
        return Static.instance!
    }
    
    func handleFacebookSignUp(parseUser: PFUser, signInVC: SignInViewController) {
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler {
            (connection, result, error: NSError!) -> Void in
            if(error != nil) {
                let errorMessage = error.localizedDescription
                signInVC.showAlert(errorMessage)
            } else if(result != nil) {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                let fName = result["first_name"]! as! String
                let lName = result["last_name"]! as! String
                let email = result["email"]! as! String
                let user = User(parseUser: parseUser)
                let id = result["id"]! as! String
                user.buildParseUser(email, fName: fName, lName: lName)
                self.currentUser = user
                
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let profileImage = self.readProfileImageFromFacebook(id)
                    user.setProfileImage(profileImage)
                    self.uploadUserDetailsToParse(user)
                }
            }
        }
    }
    
    func uploadUserDetailsToParse(user: User) {
        let pfUser = user.matchingParseObject
        pfUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if(success) {
                print("success")
            }
        }
    }
    
    func readProfileImageFromFacebook(userID: String) -> UIImage {
        let userProfileUrl = "https://graph.facebook.com/\(userID)/picture?type=large"
        let profilePictureUrl = NSURL(string: userProfileUrl)!
        let profilePicturedata = NSData(contentsOfURL: profilePictureUrl)!
        return UIImage(data: profilePicturedata)!
    }
    
    func initialisePhoneContacts(parseObject: PFObject) -> [Contact] {
        var contacts = [Contact]()
        for index in 1...4 {
            let contact = Contact(parseObject: parseObject)
            contact.type = ContactType.Phone.label
            contact.subType = ContactSubType(rawValue: index)!.label
            contacts.append(contact)
        }
        
        return contacts
    }
    
    func initialiseEmailContacts(parseObject: PFObject) -> [Contact] {
        var contacts = [Contact]()
        for index in 5...8 {
            let contact = Contact(parseObject: parseObject)
            contact.type = ContactType.Email.label
            contact.subType = ContactSubType(rawValue: index)!.label
            contacts.append(contact)
        }
        
        return contacts
    }
    
    func initialiseAddressContacts(parseObject: PFObject) -> [Contact] {
        var contacts = [Contact]()
        for index in 9...12 {
            let contact = Contact(parseObject: parseObject)
            contact.type = ContactType.Address.label
            contact.subType = ContactSubType(rawValue: index)!.label
            contacts.append(contact)
        }
        
        return contacts
    }
    
    func initialiseSocialContacts(parseObject: PFObject) -> [Contact] {
        var contacts = [Contact]()
        for index in 13...23 {
            let contact = Contact(parseObject: parseObject)
            contact.type = ContactType.Social.label
            contact.subType = ContactSubType(rawValue: index)!.label
            contacts.append(contact)
        }
        
        return contacts
    }
}