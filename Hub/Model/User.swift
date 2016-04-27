//  User.swift
//  Hub
//  Created by Irantha Rajakaruna on 6/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse
import ParseFacebookUtilsV4

class User: Hashable {
    let parseClassName = "User"
    var matchingParseObject: PFUser
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
    var contacts = [Contact]()
    var profileImage: PFFile?
    var friends: [User]?
    var requests: [User]?
    let hubModel = HubModel.sharedInstance
    
    var hashValue: Int {
        return email!.hashValue
    }
    
    init(parseUser: PFUser) {
        matchingParseObject = parseUser
    }
    
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
    
    func buildParseUser(email: String, fName: String, lName: String) {
        let defaultImage = UIImage(named: "placeholder-image")
        matchingParseObject["firstName"] = fName
        matchingParseObject["lastName"] = lName
        matchingParseObject.email = email
        setProfileImage(defaultImage!)
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
    }
    
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
    
    func logIn(userDetails: [String: String], vc: UIViewController) {
        let username = userDetails["username"]!
        let password = userDetails["password"]!
        let viewController = vc as! SignInViewController
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let currentUser = PFUser.currentUser()!
                let user = User(parseUser: currentUser)
                self.hubModel.currentUser = user
                self.hubModel.currentUser!.buildUser()
                viewController.performSegueWithIdentifier("signInSegue", sender: nil)
            } else {
                let errorMessage = error!.userInfo["error"] as? String
                viewController.showAlert(errorMessage!)
            }
        }
    }
    
    func logInWithFacebook(vc: UIViewController) {
        let viewController = vc as! SignInViewController

        PFFacebookUtils.logInInBackgroundWithReadPermissions(
            ["public_profile", "email"], block: {
                (user: PFUser?, error: NSError?) -> Void in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as! String
                    viewController.showAlert(errorMessage)
                } else if let user = user {
                    let currentUser = PFUser.currentUser()!
                    if user.isNew {
                        self.signUpWithFacebook(currentUser, signInVC: viewController)
                        viewController.performSegueWithIdentifier("createAccountSegue", sender: nil)
                    } else {
                        self.hubModel.currentUser = User(parseUser: currentUser)
                        self.hubModel.currentUser!.buildUser()
                        viewController.performSegueWithIdentifier("signInSegue", sender: nil)
                    }
                } else {
                    viewController.showAlert("Sign up error.")
                }
            }
        )
    }
    
    /* Read the profile picture data from facebook when given the user ID */
    func getProfileImageFromFacebook(userID: String) -> UIImage {
        let userProfileUrl = "https://graph.facebook.com/\(userID)/picture?type=large"
        let profilePictureUrl = NSURL(string: userProfileUrl)!
        let profilePicturedata = NSData(contentsOfURL: profilePictureUrl)!
        return UIImage(data: profilePicturedata)!
    }
    
    func saveUser(user: User) {
        let pfUser = user.matchingParseObject
        pfUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if(success) {
                print("success")
            }
        }
    }
    
    func signUpWithFacebook(parseUser: PFUser, signInVC: SignInViewController) {
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
                self.hubModel.currentUser = user
                
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let profileImage = self.getProfileImageFromFacebook(id)
                    user.setProfileImage(profileImage)
                    self.saveUser(user)
                }
            }
        }
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
                let parseUser = PFUser.currentUser()!
                let user = User(parseUser: parseUser)
                user.buildUser()
                self.hubModel.currentUser = user
                signUpVC.performSegueWithIdentifier("signUpSegue", sender: nil)
            }
        }
    }
    
    func getFriends(myContactTVC: MyContactsTableViewController) {
        let myFriendQuery = PFQuery(className: "SharedPermission")
        myFriendQuery.whereKey("user", equalTo: matchingParseObject)
        myFriendQuery.whereKey("status", equalTo: "accepted")
        
        let iAmAFriendOfQuery = PFQuery(className: "SharedPermission")
        iAmAFriendOfQuery.whereKey("userFriend", equalTo: matchingParseObject)
        iAmAFriendOfQuery.whereKey("status", equalTo: "accepted")
        
        let query = PFQuery.orQueryWithSubqueries([myFriendQuery, iAmAFriendOfQuery])
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                var myFriends = [User]()
                for object in objects {
                    let fromUser = object["userFriend"] as! PFUser
                    let toUser = object["user"] as! PFUser
                    var user: PFUser?
                    
                    if fromUser.objectId == self.matchingParseObject.objectId {
                        user = object["user"] as? PFUser
                    }
                    
                    if toUser.objectId == self.matchingParseObject.objectId {
                        user = object["userFriend"] as? PFUser
                    }
                    
                    user!.fetchInBackgroundWithBlock {
                        (fetchedUser: PFObject?, error: NSError?) -> Void in
                        let fetchedFromUser = fetchedUser as! PFUser
                        let request = User(parseUser: fetchedFromUser)
                        request.buildUser()
                        myFriends.append(request)
                        myContactTVC.myContacts = myFriends.sort { $0.firstName < $1.firstName }
                        myContactTVC.refreshTableViewInBackground()
                    }
                }
            }
        }
    }
    
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
    
    func getContacts(myProfileVC: MyProfileViewController) {
        let myContacts = matchingParseObject.objectForKey("contacts")
        if let myContacts = myContacts {
            for parseObject in myContacts as! [PFObject] {
                parseObject.fetchInBackgroundWithBlock {
                    (fetchedContact: PFObject?, error: NSError?) -> Void in
                    
                    let contact = Contact(parseObject: fetchedContact!)
                    contact.buildContact()
                    self.contacts.append(contact)
                    switch contact.type! {
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
                    myProfileVC.phoneButtonPressed()
                }
            }
        }
    }
    
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
    
    func getRequestedContacts(friend: User, contactRequestTVC: ContactRequestTableViewController) {
        let parseSPObject = PFObject(className: "SharedPermission")
        let sharedPermisson = SharedPermission(parseObject: parseSPObject)
        sharedPermisson.getContacts(self, friend: friend, contactRequestTVC: contactRequestTVC)
    }
    
    func hideProfile(isHidden: Bool) {
        matchingParseObject["profileIsVisible"] = isHidden
        matchingParseObject.saveInBackground()
    }
    
    func setContacts(contacts: [Contact]) {
        let contactsToSave = contactsToSaveArray(contacts)
        let contactsToDelete = contactsToDeleteArray(contacts)
        
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
    
    // Private method that needs set contacts to work properly
    func contactsToDeleteArray(contacts: [Contact]) -> [PFObject] {
        var returnArray = [PFObject]()
        for contact in contacts {
            if contact.value == "" {
                contact.buildParseObject("", type: "", subType: "")
                contact.matchingParseObject.objectId = contact.objectId
                returnArray.append(contact.matchingParseObject)
            }
        }
        return returnArray
    }
    
    func contactsToSaveArray(contacts: [Contact]) -> [PFObject] {
        var returnArray = [PFObject]()
        for contact in contacts {
            if contact.value != "" {
                contact.buildParseObject(contact.value!, type: contact.type!, subType: contact.subType!)
                contact.matchingParseObject.objectId = contact.objectId
                returnArray.append(contact.matchingParseObject)
            }
        }
        return returnArray
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}