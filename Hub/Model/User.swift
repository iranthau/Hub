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
    var firstName: String?
    var lastName: String?
    var nickname: String?
    var email: String?
    var profileIsVisible: Bool?
    var availableTime: String?
    var city: String?
    var profileImage: PFFile?
    let defaultProfileImage: UIImage
    var matchingParseObject: PFUser
    var contacts = [Contact]()
    var friends = [User]()
    var requests: [User]?
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
        matchingParseObject["availableTime"] = availableTime!
    }
    
    func setFirstName() {
        matchingParseObject["firstName"] = firstName!
    }
    
    func setLastName() {
        matchingParseObject["lastName"] = lastName!
    }
    
    func setNickame() {
        matchingParseObject["nickName"] = nickname!
    }
    
    func setCity() {
        matchingParseObject["city"] = city!
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
    
    func logIn(userDetails: [String: String], vc: BaseViewController) {
        let username = userDetails["username"]!
        let password = userDetails["password"]!
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let currentUser = PFUser.currentUser()!
                self.matchingParseObject = currentUser
                self.buildUser()
                self.hubModel.setCurrentUser(self)
                vc.performSegueWithIdentifier("signInSegue", sender: nil)
            } else {
                let errorMessage = error!.userInfo["error"] as? String
                vc.showAlert(errorMessage!)
            }
        }
    }
    
    func logInWithFacebook(vc: BaseViewController) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(
            ["public_profile", "email"], block: {
                (user: PFUser?, error: NSError?) -> Void in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as! String
                    vc.showAlert(errorMessage)
                } else if let user = user {
                    let currentUser = PFUser.currentUser()!
                    if user.isNew {
                        self.signUpWithFacebook(currentUser, signInVC: vc)
                        vc.performSegueWithIdentifier("createAccountSegue", sender: nil)
                    } else {
                        self.matchingParseObject = currentUser
                        self.buildUser()
                        self.hubModel.setCurrentUser(self)
                        vc.performSegueWithIdentifier("signInSegue", sender: nil)
                    }
                } else {
                    vc.showAlert("Sign up error.")
                }
            }
        )
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
                self.matchingParseObject = PFUser.currentUser()!
                self.buildUser()
                self.hubModel.setCurrentUser(self)
                signUpVC.performSegueWithIdentifier("signUpSegue", sender: nil)
            }
        }
    }
    
    func logOut(vc: UIViewController) {
        let settingsVC = vc as! SettingsViewController
        PFUser.logOutInBackgroundWithBlock({ (error: NSError?) -> Void in
            if(error == nil) {
                settingsVC.performSegueWithIdentifier("signOutSegue", sender: nil)
            }
        })
    }
    
    /* Get a list of all my friends from Parse. Need two queries to perform the 
     * the action since we need both friends that I am a friend of and my friends */
    func getAllFriends(myContactTVC: MyContactsTableViewController) {
        let sPParseObject = PFObject(className: "SharedPermission")
        let sharedPermission = SharedPermission(parseObject: sPParseObject)
        let myFriendQuery = sharedPermission.buildFriendQuery("user", objectForTheField: matchingParseObject)
        let iAmAFriendOfQuery = sharedPermission.buildFriendQuery("userFriend", objectForTheField: matchingParseObject)
        let query = PFQuery.orQueryWithSubqueries([myFriendQuery, iAmAFriendOfQuery])
        
        query.findObjectsInBackgroundWithBlock {
            (sharedPermissionObjects: [PFObject]?, error: NSError?) -> Void in
            if let sPObjects = sharedPermissionObjects {
                for sPObject in sPObjects {
                    let user = self.getMatchingUser(sPObject)
                    user.fetchInBackgroundWithBlock {
                        (fetchedUser: PFObject?, error: NSError?) -> Void in
                        if let fetchedFromUser = fetchedUser as? PFUser {
                            let request = User(parseUser: fetchedFromUser)
                            request.buildUser()
                            self.friends.append(request)
                            myContactTVC.myContacts = self.friends.sort { $0.firstName < $1.firstName }
                            myContactTVC.refreshTableViewInBackground()
                        }
                    }
                }
            }
        }
    }
    
    /* Get all contacts that a friend has shared with me */
    func getAllSharedContacts(friend: User, profileContactVC: ProfileContactViewController) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: friend.matchingParseObject)
        query.whereKey("userFriend", equalTo: matchingParseObject)
        
        query.getFirstObjectInBackgroundWithBlock {
            (sharedPermission: PFObject?, error: NSError?) -> Void in
            if let sharedPermission = sharedPermission {
                let contacts = sharedPermission.objectForKey("contacts")
                
                for contact in contacts as! [PFObject] {
                    contact.fetchInBackgroundWithBlock {
                        (fetchedContact: PFObject?, error: NSError?) -> Void in
                        
                        let sharedContact = Contact(parseObject: fetchedContact!)
                        sharedContact.buildContact()
                        
                        switch sharedContact.type! {
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
    
    // Get contacts I shared with a friend
    func getContactsIShared(friend: User, profileContactVC: ProfileContactViewController) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("userFriend", equalTo: friend.matchingParseObject)
        query.whereKey("user", equalTo: matchingParseObject)
        query.whereKey("status", equalTo: "accepted")
        
        query.getFirstObjectInBackgroundWithBlock {
            (sharedPermission: PFObject?, error: NSError?) -> Void in
            
            if let sharedPermission = sharedPermission {
                let contacts = sharedPermission.objectForKey("contacts") as! [PFObject]
                
                for contact in contacts {
                    contact.fetchInBackgroundWithBlock {
                        (fetchedContact: PFObject?, error: NSError?) -> Void in
                        let sharedContact = Contact(parseObject: fetchedContact!)
                        sharedContact.buildContact()
                        profileContactVC.mySharedContacts.append(sharedContact)
                        profileContactVC.mySharedContactsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //Get my own contacts
    func getContacts(myProfileVC: MyProfileViewController) {
        let myContacts = matchingParseObject.objectForKey("contacts")
        if let myContacts = myContacts {
            for parseObject in myContacts as! [PFObject] {
                parseObject.fetchInBackgroundWithBlock {
                    (fetchedContact: PFObject?, error: NSError?) -> Void in
                    
                    let contact = Contact(parseObject: fetchedContact!)
                    contact.buildContact()
                    self.contacts.append(contact)
                    myProfileVC.allContacts.append(contact)
                    if myContacts.lastObject as! PFObject == parseObject {
                        myProfileVC.groupContacts()
                    }
                    myProfileVC.phoneButtonPressed()
                }
            }
        }
    }
    
    // Get a list of contacts that a friend has offered to share
    func getAvailableContacts(tableVC: AddContactViewController) {
        let parseObjects = matchingParseObject.objectForKey("contacts")
        
        if let parseObjects = parseObjects as? [PFObject] {
            for parseObject in parseObjects {
                parseObject.fetchInBackgroundWithBlock {
                    (fetchedContact: PFObject?, error: NSError?) -> Void in
                    
                    let contact = Contact(parseObject: fetchedContact!)
                    contact.buildContact()
                    tableVC.contacts.append(contact)
                    tableVC.contactSelectionTableView.reloadData()
                }
            }
        }
    }
    
    //Get a list of friends that asked to connect with me
    func getRequests(requestsTVC: RequestsTableViewController) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: matchingParseObject)
        query.whereKey("status", equalTo: "pending")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                for object in objects {
                    let fromUser = object["userFriend"] as! PFUser
                    fromUser.fetchInBackgroundWithBlock {
                        (fetchedUser: PFObject?, error: NSError?) -> Void in
                        let fetchedFromUser = fetchedUser as! PFUser
                        let request = User(parseUser: fetchedFromUser)
                        request.buildUser()
                        requestsTVC.requests.append(request)
                        requestsTVC.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //Get a list of contacts that a friend has asked to share
    func getRequestedContacts(friend: User, contactRequestTVC: ContactRequestTableViewController) {
        let parseSPObject = PFObject(className: "SharedPermission")
        let sharedPermisson = SharedPermission(parseObject: parseSPObject)
        sharedPermisson.getContacts(self, friend: friend, contactRequestTVC: contactRequestTVC)
    }
    
    /* Update contacts for a user when the user update them. Also will remove
     * the deleted/ empty contacts from parse for the user */
    func setContacts(contacts: [Contact]) {
        let contactsToSave = contactsToSaveArray(contacts)
        let contactsToDelete = contactsToDeleteArray(contacts)
        
        self.setAvailableTime()
        self.setFirstName()
        self.setLastName()
        self.setNickame()
        self.setCity()
        self.matchingParseObject["contacts"] = contactsToSave
        self.matchingParseObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) in
            if success {
                for contactToDelete in contactsToDelete {
                    contactToDelete.deleteInBackground()
                }
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
    
    /* Enable a unique hash value for each user based on email. So the value can be used
     * to compare user with other users for equality */
    var hashValue: Int {
        return email!.hashValue
    }
    
    //---------------------Private methods-----------------------------
    private func signUpWithFacebook(parseUser: PFUser, signInVC: BaseViewController) {
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler {
            (connection, result, error: NSError!) -> Void in
            if(error != nil) {
                let errorMessage = error.localizedDescription
                signInVC.showAlert(errorMessage)
            } else if(result != nil) {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                self.firstName = result["first_name"]! as? String
                self.lastName = result["last_name"]! as? String
                self.email = result["email"]! as? String
                self.matchingParseObject = parseUser
                self.objectId = result["id"]! as? String
                self.buildParseUser()
                self.hubModel.setCurrentUser(self)
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let profileImage = self.getProfileImageFromFacebook()
                    self.setProfileImage(profileImage)
                    self.saveUser()
                }
            }
        }
    }
    
    /* Read the profile picture data from facebook when given the user ID */
    private func getProfileImageFromFacebook() -> UIImage {
        let userProfileUrl = "https://graph.facebook.com/\(objectId!)/picture?type=large"
        let profilePictureUrl = NSURL(string: userProfileUrl)!
        let profilePicturedata = NSData(contentsOfURL: profilePictureUrl)!
        return UIImage(data: profilePicturedata)!
    }
    
    private func saveUser() {
        matchingParseObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if(success) {
                print("success")
            }
        }
    }
    
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
    
    /* Returns a parse user object that doesn't match the current user */
    private func getMatchingUser(sPObject: PFObject) -> PFUser {
        let fromUser = sPObject["userFriend"] as! PFUser
        let toUser = sPObject["user"] as! PFUser
        var user: PFUser?
        if fromUser.objectId == self.objectId! {
            user = sPObject["user"] as? PFUser
        }
        
        if toUser.objectId == self.objectId! {
            user = sPObject["userFriend"] as? PFUser
        }
        return user!
    }
}

//Enable user comparing
func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}