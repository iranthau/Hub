// User.swift
// Hub
// Created by Irantha Rajakaruna on 6/02/2016.
// Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse
import ParseFacebookUtilsV4

class User: Hashable {
    var objectId: String?
    var username: String?
    var password: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var nickname: String?
    var profileIsVisible: Bool?
    var availableTime: String?
    var city: String?
    var profileImage: PFFile?
    let defaultProfileImage: UIImage
    var matchingParseObject: PFUser
    var contacts = [Contact]()
    var friends = [User]()
    var requests: [User]?
    var isNew = false
    let hubModel = HubModel.sharedInstance
    
    // A user can be intialise with a parse user object
    init(parseUser: PFUser) {
        matchingParseObject = parseUser
        defaultProfileImage = UIImage(named: "placeholder-image")!
    }
    
    /* Whenever a user is being initialise the object need to be build using the method.
     * Assigns values to user attributes from parse object */
    func buildUser() {
        objectId = matchingParseObject.objectId!
        username = matchingParseObject.username!
        email = matchingParseObject.email!
        firstName = matchingParseObject["firstName"] as? String
        lastName = matchingParseObject["lastName"] as? String
        nickname = matchingParseObject["nickName"] as? String
        profileIsVisible = matchingParseObject["profileIsVisible"] as? Bool
        availableTime = matchingParseObject["availableTime"] as? String
        city = matchingParseObject["city"] as? String
        profileImage = matchingParseObject["profileImage"] as? PFFile
    }
    
    // Build the parse object with provided values
    func buildParseUser() {
        matchingParseObject["firstName"] = firstName!
        matchingParseObject["lastName"] = lastName!
        matchingParseObject.email = email!
        setProfileImage(defaultProfileImage)
        matchingParseObject["profileIsVisible"] = true
    }
    
    func setUsername(username: String) {
        matchingParseObject.username = username
    }
    
    func setPassword(password: String) {
        matchingParseObject.password = password
    }
    
    func setProfileImage(image: UIImage) {
        matchingParseObject["profileImage"] = HubUtility.convertImageFileToParseFile(image)
        profileImage = HubUtility.convertImageFileToParseFile(image)
    }
    
    func setAvailableTime() {
        if let availableTime = availableTime {
            matchingParseObject["availableTime"] = availableTime
        }
    }
    
    func setFirstName() {
        matchingParseObject["firstName"] = firstName!
    }
    
    func setLastName() {
        matchingParseObject["lastName"] = lastName!
    }
    
    func setNickame() {
        if let nickname = nickname {
            matchingParseObject["nickName"] = nickname
        }
    }
    
    func setCity() {
        if let city = city {
            matchingParseObject["city"] = city
        }
    }
    
    // Return true if a user has any contacts to share
    func hasSharedContacts() -> Bool {
        return matchingParseObject.objectForKey("contacts") != nil
    }
    
    func hideProfile(isHidden: Bool) {
        matchingParseObject["profileIsVisible"] = isHidden
        matchingParseObject.saveInBackground()
    }
    
    func sendRequest(sharedPermission: SharedPermission, pushNotification: PFPush, vc: BaseViewController) {
        sharedPermission.saveInParse(pushNotification, vc: vc)
    }
    
    /* Get the profile image from parse and assignes it to an imageview */
    func getProfileImage(imageView: UIImageView) {
        profileImage!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    imageView.image = UIImage(data:imageData)
                }
            }
        }
    }
    
    func logIn(userDetails: [String: String], completion: (success: User?, error: String?) -> Void) {
        HubAPI.logIn(userDetails) {
            (pfUser: PFUser?, error: NSError?) -> Void in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(success: nil, error: errorMessage)
            } else {
                self.matchingParseObject = pfUser!
                self.buildUser()
                completion(success: self, error: nil)
            }
        }
    }
    
    func logInWithFacebook(completion: (success: User?, error: String?) -> Void) {
        HubAPI.logInWithFacebook {
            (user: PFUser?, error: NSError?) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as! String
                completion(success: nil, error: errorMessage)
            } else if let user = user {
                if user.isNew {
                    HubAPI.readFacebookPublicProfile {
                        (result: NSDictionary?, error: NSError?) in
                        if let error = error {
                            let errorMessage = error.userInfo["error"] as! String
                            completion(success: nil, error: errorMessage)
                        } else {
                            self.matchingParseObject = user
                            self.firstName = result!["first_name"]! as? String
                            self.lastName = result!["last_name"]! as? String
                            self.email = result!["email"]! as? String
                            self.isNew = true
                            self.buildParseUser()
                            let image = result!["profile-image"] as? UIImage
                            self.setProfileImage(image!)
                            completion(success: self, error: nil)
                        }
                    }
                } else {
                    self.matchingParseObject = user
                    self.buildUser()
                    completion(success: self, error: nil)
                }
            }
        }
    }
    
    func signUp(completion: (user: User?, error: String?) -> Void) {
        HubAPI.signUp(matchingParseObject) {
            (user: PFUser?, error: NSError?) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(user: nil, error: errorMessage)
            } else {
                self.matchingParseObject = user!
                self.buildUser()
                completion(user: self, error: nil)
            }
        }
    }
    
    func logOut(completion: (error: String?) -> Void) {
        HubAPI.logOut {
            (error) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(error: errorMessage)
            } else {
                completion(error: nil)
            }
        }
    }
    
    func getAllFriends(completion: (friends: [User]?, error: String?) -> Void) {
        let sPParseObject = PFObject(className: "SharedPermission")
        let sharedPermission = SharedPermission(parseObject: sPParseObject)
        let myFriendQuery = sharedPermission.buildFriendQuery("user", objectForTheField: matchingParseObject)
        let iAmAFriendOfQuery = sharedPermission.buildFriendQuery("userFriend", objectForTheField: matchingParseObject)
        let query = PFQuery.orQueryWithSubqueries([myFriendQuery, iAmAFriendOfQuery])
        
        HubAPI.getAllFriends(matchingParseObject, query: query) {
            (pUsers, error) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(friends: nil, error: errorMessage)
            } else {
                var allFriends = [User]()
                if let pUsers = pUsers {
                    for pUser in pUsers {
                        let friend = User(parseUser: pUser)
                        friend.buildUser()
                        allFriends.append(friend)
                    }
                }
                let uniqueFriends = allFriends.removeDuplicates()
                completion(friends: uniqueFriends, error: nil)
            }
        }
    }
    
    /* Get all contacts that a friend has shared with me */
    func getAllSharedContacts(friend: User?, completion: (contacts: [Contact]?, error: String?) -> Void) {
        if let friend = friend {
            let query = PFQuery(className: "SharedPermission")
            query.whereKey("user", equalTo: friend.matchingParseObject)
            query.whereKey("userFriend", equalTo: matchingParseObject)
            query.whereKey("status", equalTo: "accepted")
            query.includeKey("contacts")
            
            HubAPI.getSharedContacts(query) {
                (pContacts: [PFObject]?, error: NSError?) in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as? String
                    completion(contacts: nil, error: errorMessage)
                } else if let pContacts = pContacts {
                    var contacts = [Contact]()
                    for pContact in pContacts {
                        let sharedContact = Contact(parseObject: pContact)
                        sharedContact.buildContact()
                        contacts.append(sharedContact)
                    }
                    completion(contacts: contacts, error: nil)
                }
            }
        }
    }
    
    // Get contacts I shared with a friend
    func getContactsIShared(friend: User?, completion: (contacts: [Contact]?, error: String?) -> Void) {
        if let friend = friend {
            let query = PFQuery(className: "SharedPermission")
            query.whereKey("userFriend", equalTo: friend.matchingParseObject)
            query.whereKey("user", equalTo: matchingParseObject)
            query.whereKey("status", equalTo: "accepted")
            query.includeKey("contacts")
            
            HubAPI.getSharedContacts(query) {
                (pContacts: [PFObject]?, error: NSError?) in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as? String
                    completion(contacts: nil, error: errorMessage)
                } else if let pContacts = pContacts {
                    var contacts = [Contact]()
                    for pContact in pContacts {
                        let sharedContact = Contact(parseObject: pContact)
                        sharedContact.buildContact()
                        contacts.append(sharedContact)
                    }
                    completion(contacts: contacts, error: nil)
                }
            }
        }
    }
    
    //Get my own contacts
    func getContacts(completion: (contacts: [Contact]?, error: String?) -> Void) {
        var contactsToReturn = [Contact]()
        HubAPI.getContacts(matchingParseObject) {
            (contacts: [PFObject]?, error: NSError?) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(contacts: nil, error: errorMessage)
            } else if let contacts = contacts {
                for pContact in contacts {
                    let contact = Contact(parseObject: pContact)
                    contact.buildContact()
                    contactsToReturn.append(contact)
                    self.contacts.append(contact)
                }
                completion(contacts: contactsToReturn, error: nil)
            }
        }
    }
    
    //Get a list of friends that asked to connect with me
    func getRequests(completion: (requests: [User]?, error: String?) -> Void) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: matchingParseObject)
        query.whereKey("status", equalTo: "pending")
        query.includeKey("userFriend")
        
        HubAPI.getRequests(query) {
            (pRequests: [PFUser]?, error: NSError?) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(requests: nil, error: errorMessage)
            } else if let pRequests = pRequests {
                var requests = [User]()
                for pRequest in pRequests {
                    let request = User(parseUser: pRequest)
                    request.buildUser()
                    requests.append(request)
                }
                completion(requests: requests, error: nil)
            }
        }
    }
    
    //Get a list of contacts that a friend has asked to share
    func getRequestedContacts(friend: User?, completion: (contacts: [Contact]?, error: String?) -> Void) {
        if let friend = friend {
            let query = PFQuery(className: "SharedPermission")
            query.whereKey("userFriend", equalTo: friend.matchingParseObject)
            query.whereKey("user", equalTo: matchingParseObject)
            query.whereKey("status", equalTo: "pending")
            query.includeKey("contacts")
            
            HubAPI.getSharedContacts(query) {
                (pContacts: [PFObject]?, error: NSError?) in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as? String
                    completion(contacts: nil, error: errorMessage)
                } else if let pContacts = pContacts {
                    var contacts = [Contact]()
                    for pContact in pContacts {
                        let contact = Contact(parseObject: pContact)
                        contact.buildContact()
                        contacts.append(contact)
                    }
                    completion(contacts: contacts, error: nil)
                }
            }
        }
    }
    
    /* Update contacts for a user when the user update them. Also will remove
     * the deleted/ empty contacts from parse for the user */
    func setContacts(contacts: [Contact], completion: (Bool, String?) -> Void) {
        let contactsToSave = contactsToSaveArray(contacts)
        let contactsToDelete = contactsToDeleteArray(contacts)
        
        self.setAvailableTime()
        self.setFirstName()
        self.setLastName()
        self.setNickame()
        self.setCity()
        self.matchingParseObject["contacts"] = contactsToSave
        HubAPI.saveParseUser(matchingParseObject) {
            (success: Bool, error: NSError?) in
            if success {
                HubAPI.deleteABatchOfObjects(contactsToDelete, completion: {
                    (success, error) in
                    if success {
                        completion(true, nil)
                    } else if let error = error {
                        let errorMessage = error.userInfo["error"] as? String
                        completion(false, errorMessage)
                    }
                })
            } else if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(false, errorMessage)
            }
        }
    }
    
    func acceptRequest(friend: PFUser, push: PFPush, viewController: UIViewController) {
        let contactRTVC = viewController as! ContactRequestTableViewController
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: matchingParseObject)
        query.whereKey("userFriend", equalTo: friend)
        
        query.getFirstObjectInBackgroundWithBlock {
            (sharedPermission: PFObject?, error: NSError?) in
            if let sharedPermission = sharedPermission {
                sharedPermission["contacts"] = contactRTVC.acceptedContacts
                sharedPermission["status"] = "accepted"
                sharedPermission.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) in
                    if success {
                        push.sendPushInBackground()
                        contactRTVC.navigateBack()
                    }
                }
            }
        }
    }
    
    //Current user can delete his account. This will delete all records for that user.
    func deleteAccount(vc: UIViewController) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let settingsVC = vc as! SettingsViewController
        let contacts = matchingParseObject.objectForKey("contacts") as? [PFObject]
        deleteEntriesAsUserInSharedPermission()
        deleteEntriesAsFriendFromSharedPermission()
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.deleteContacts(contacts)
            dispatch_async(dispatch_get_main_queue()) {
                self.deleteUser(settingsVC)
            }
        }
    }
    
    func searchForFriends(textToSearch: String, tvc: UITableViewController) {
        let addContactTVC = tvc as! AddContactTableViewController
        let query = PFUser.query()
        query!.whereKey("firstName", hasPrefix: textToSearch)
        query!.whereKey("profileIsVisible", equalTo: true)
        query!.whereKey("objectId", notEqualTo: objectId!)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                var profiles = [User]()
                if let objects = objects {
                    for userObject in objects as! [PFUser] {
                        let user = User(parseUser: userObject)
                        user.buildUser()
                        profiles.append(user)
                    }
                    addContactTVC.filteredContacts = profiles
                    addContactTVC.tableView.reloadData()
                }
            }
        }
    }
    
    func resetPassword(email: String, vc: PassswordRecoveryViewController) {
        PFUser.requestPasswordResetForEmailInBackground(email) {
            (success: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                vc.showAlert(errorMessage!)
            } else {
                vc.showAlert("Email sent to \(email)")
            }
        }
    }
    
    func saveUser(completion: (success: Bool, error: String?) -> Void) {
        HubAPI.saveParseUser(matchingParseObject) {
            (success: Bool, error: NSError?) in
            if let error = error {
                let errorMessage = error.userInfo["error"] as? String
                completion(success: success, error: errorMessage)
            } else {
                completion(success: success, error: nil)
            }
        }
    }
    
    /* Enable a unique hash value for each user based on email. So the value can be used
     * to compare user with other users for equality */
    var hashValue: Int {
        return email!.hashValue
    }
    
    //---------------------Private methods-----------------------------
    
    /* If the contact value is empty after a user update his contacts those contacts
     * will be deleted from parse */
    private func contactsToDeleteArray(contacts: [Contact]) -> [PFObject] {
        var returnArray = [PFObject]()
        for contact in contacts {
            if contact.value == "" {
                contact.buildParseContact()
                contact.setObjectId()
                returnArray.append(contact.matchingParseObject)
            }
        }
        return returnArray
    }
    
    private func contactsToSaveArray(contacts: [Contact]) -> [PFObject] {
        var returnArray = [PFObject]()
        self.contacts.removeAll()
        for contact in contacts {
            if contact.value != "" {
                contact.buildParseContact()
                contact.setObjectId()
                returnArray.append(contact.matchingParseObject)
                self.contacts.append(contact)
            }
        }
        return returnArray
    }
    
    private func deleteEntriesAsFriendFromSharedPermission() {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("userFriend", equalTo: matchingParseObject)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) in
            if let objects = objects {
                for object in objects {
                    object.deleteInBackground()
                }
            }
        }
    }
    
    private func deleteEntriesAsUserInSharedPermission() {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: matchingParseObject)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) in
            if let objects = objects {
                for object in objects {
                    object.deleteInBackground()
                }
            }
        }
    }
    
    private func deleteUser(settingsVC: SettingsViewController) {
        matchingParseObject.deleteInBackgroundWithBlock {
            (success: Bool, error: NSError?) in
            if success {
                PFUser.logOut()
                settingsVC.performSegueWithIdentifier("signOutSegue", sender: nil)
            }
        }
    }
    
    private func deleteContacts(contacts: [PFObject]?) {
        if let contacts = contacts {
            for contact in contacts {
                do {
                    try contact.delete()
                } catch {
                    print("\(contact.objectId) could not be deleted")
                }
            }
        }
    }
}

//Enable user comparing
func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}