//
//  User.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 6/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class User: Hashable {
    let parseClassName = "User"
    var matchingParseObject: PFUser
    var objectId: String
    var username: String
    var password: String?
    var email: String
    var firstName: String
    var lastName: String
    var nickname: String?
    var profileIsVisible: Bool
    var availableTime: String?
    var city: String?
    var contacts: [Contact]?
    var profileImage: PFFile
    var friends: [User]?
    var requests: [User]?
    let hubModel = HubModel.sharedInstance
    
    var hashValue: Int {
        return email.hashValue
    }
    
    init(parseUser: PFUser) {
        matchingParseObject = parseUser
        objectId = parseUser.objectId!
        username = parseUser.username!
        email = parseUser.email!
        firstName = parseUser["firstName"] as! String
        lastName = parseUser["lastName"] as! String
        nickname = parseUser["nickName"] as? String
        profileIsVisible = parseUser["profileIsVisible"] as! Bool
        availableTime = parseUser["availableTime"] as? String
        city = parseUser["city"] as? String
        profileImage = parseUser["profileImage"] as! PFFile
    }
    
    func setUpParseUser(email: String, fName: String, lName: String) {
        matchingParseObject = PFUser()
        matchingParseObject["firstName"] = fName
        matchingParseObject["lastName"] = lName
        matchingParseObject.email = email
        let defaultImage = UIImage(named: "placeholder-image")
        matchingParseObject["profileImage"] = imageAsParseFile(defaultImage!)
        matchingParseObject["profileIsVisible"] = true
    }
    
    func setUsername(username: String) {
        matchingParseObject.username = username
    }
    
    func setPassword(password: String) {
        matchingParseObject.password = password
    }
    
    func setProfileImage(image: UIImage) {
        matchingParseObject["profileImage"] = imageAsParseFile(image)
    }
    
    func imageAsParseFile(image: UIImage) -> PFFile {
        let profileImageData = image.lowQualityJPEGNSData
        return PFFile(data: profileImageData)!
    }
    
    func signUp(signUpVC: SignUpViewController) {
        matchingParseObject.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) in
            if let error = error {
                signUpVC.activityIndicator.stopAnimating()
                let errorMessage = error.userInfo["error"] as? String
                signUpVC.showAlert(errorMessage!)
            } else {
                signUpVC.activityIndicator.stopAnimating()
                let user = PFUser.currentUser()!
                self.hubModel.currentUser = User(parseUser: user)
                signUpVC.performSegueWithIdentifier("signUpSegue", sender: nil)
            }
        }
    }
    
    func getFriends(myContactTVC: MyContactsTableViewController) {
        let relation = matchingParseObject.relationForKey("friends")
        let query = relation.query()
        
        query.findObjectsInBackgroundWithBlock {
            (friends: [PFObject]? , error: NSError?) -> Void in
            
            if error == nil {
                if let friends = friends {
                    var myFriends = [User]()
                    for friend in friends as! [PFUser] {
                        myFriends.append(User(parseUser: friend))
                    }
                    myContactTVC.myContacts = myFriends.sort { $0.firstName < $1.firstName }
                    myContactTVC.refreshTableViewInBackground()
                }
            }
        }
    }
    
    func getAllSharedContacts(friend: User, profileContactVC: ProfileContactViewController) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: friend.matchingParseObject)
        query.whereKey("userFriend", equalTo: matchingParseObject)
        
        query.findObjectsInBackgroundWithBlock {
            (sharedPermissions: [PFObject]?, error: NSError?) -> Void in
            
            if let sharedPermissions = sharedPermissions {
                for sharedPermission in sharedPermissions {
                    let contact = sharedPermission.objectForKey("contact") as! PFObject
                    
                    contact.fetchInBackgroundWithBlock {
                        (fetchedContact: PFObject?, error: NSError?) -> Void in
                        
                        let sharedContact = Contact(parseObject: fetchedContact!)
                        
                        switch sharedContact.type {
                        case ContactType.Phone.label:
                            profileContactVC.sharedPhoneContacts.append(sharedContact)
                        case ContactType.Email.label:
                            profileContactVC.sharedEmailContacts.append(sharedContact)
                        case ContactType.Address.label:
                            profileContactVC.sharedAddressContacts.append(sharedContact)
                        case ContactType.Social.label:
                            profileContactVC.sharedSocialContacts.append(sharedContact)
                        default:
                            return
                        }
                        profileContactVC.refreshTableView()
                    }
                }
            }
        }
    }
    
    func getContactsIShared(friend: User, profileContactVC: ProfileContactViewController) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("userFriend", equalTo: friend.matchingParseObject)
        query.whereKey("user", equalTo: matchingParseObject)
        
        query.findObjectsInBackgroundWithBlock {
            (sharedPermissions: [PFObject]?, error: NSError?) -> Void in
            
            if let sharedPermissions = sharedPermissions {
                for sharedPermission in sharedPermissions {
                    let contact = sharedPermission.objectForKey("contact") as! PFObject
                    
                    contact.fetchInBackgroundWithBlock {
                        (fetchedContact: PFObject?, error: NSError?) -> Void in
                        let sharedContact = Contact(parseObject: fetchedContact!)
                        profileContactVC.mySharedContacts.append(sharedContact)
                        profileContactVC.mySharedContactsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getContacts(myProfileVC: MyProfileViewController) {
        let myContacts = matchingParseObject.objectForKey("contacts")
        for parseObject in myContacts as! [PFObject] {
            
            parseObject.fetchInBackgroundWithBlock {
                (fetchedContact: PFObject?, error: NSError?) -> Void in
                
                let contact = Contact(parseObject: fetchedContact!)
                
                switch contact.type {
                case ContactType.Phone.label:
                    myProfileVC.sharedPhoneContacts.append(contact)
                case ContactType.Email.label:
                    myProfileVC.sharedEmailContacts.append(contact)
                case ContactType.Address.label:
                    myProfileVC.sharedAddressContacts.append(contact)
                case ContactType.Social.label:
                    myProfileVC.sharedSocialContacts.append(contact)
                default:
                    return
                }
                myProfileVC.tableView.reloadData()
            }
        }
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}