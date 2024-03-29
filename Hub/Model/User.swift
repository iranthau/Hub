// User.swift
// Hub
// Created by Irantha Rajakaruna on 6/02/2016.
// Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse

class User: PFUser {
  @NSManaged var firstName: String
  @NSManaged var lastName: String
  @NSManaged var nickname: String?
  @NSManaged var profileIsVisible: Bool
  @NSManaged var availableTime: String?
  @NSManaged var city: String?
  @NSManaged private var profileImage: PFFile
  @NSManaged var contacts: [Contact]
  
  private override init() {
    super.init()
  }
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  convenience init(firstName: String, lastName: String, email: String) {
    self.init()
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.username = email
    self.profileIsVisible = true
  }
  
  func getProfileImage(completion: (image: UIImage?) -> Void) {
    profileImage.getDataInBackgroundWithBlock {
      (imageData: NSData?, error: NSError?) -> Void in
      if error == nil {
        if let imageData = imageData {
          let image = UIImage(data:imageData)
          completion(image: image)
        }
      }
    }
  }
  
  func setProfilePicture(image: UIImage?) {
    var imageData: NSData?
    if let image = image {
      imageData = image.lowQualityJPEGNSData
    } else {
      let defaultImage = UIImage(named: "placeholder-image")
      imageData = defaultImage?.lowQualityJPEGNSData
    }
    
    if let imageData = imageData {
      profileImage = PFFile(data: imageData)!
    }
  }
  
  class func logIn(userDetails: [String: String], completion: (success: User?, error: String?) -> Void) {
    let username = userDetails["username"]!
    let password = userDetails["password"]!
    
    self.logInWithUsernameInBackground(username, password: password) {
      (pUser: PFUser?, error: NSError?) -> Void in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(success: nil, error: errorMessage)
      } else if let pUser = pUser as? User {
        completion(success: pUser, error: nil)
      }
    }
  }
  
  class func logInWithFacebook(completion: (success: User?, error: String?) -> Void) {
    HubAPI.logInWithFacebook { (pUser: PFUser?, error: NSError?) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as! String
        completion(success: nil, error: errorMessage)
      } else if let pUser = pUser as? User {
        if pUser.isNew {
          HubAPI.readFacebookPublicProfile {
            (result: NSDictionary?, error: NSError?) in
            if let error = error {
              let errorMessage = error.userInfo["error"] as! String
              completion(success: nil, error: errorMessage)
            } else if let result = result {
              pUser.firstName = result["first_name"] as! String
              pUser.lastName = result["last_name"] as! String
              pUser.email = result["email"] as? String
              let pImage = result["profile-image"] as? UIImage
              pUser.setProfilePicture(pImage)
              pUser.profileIsVisible = true
              completion(success: pUser, error: nil)
            }
          }
        } else {
          completion(success: pUser, error: nil)
        }
      }
    }
  }
  
  func signMeUp(completion: (user: User?, error: String?) -> Void) {
    self.signUpInBackgroundWithBlock {
      (success: Bool, error: NSError?) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(user: nil, error: errorMessage)
      } else {
        let curretUser = PFUser.currentUser() as? User
        completion(user: curretUser, error: nil)
      }
    }
  }
  
  func logOut(completion: (error: String?) -> Void) {
    PFUser.logOutInBackgroundWithBlock {
      (error: NSError?) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(error: errorMessage)
      } else {
        completion(error: nil)
      }
    }
  }
  
  func getFriends(completion: (friends: [User]?, error: String?) -> Void) {
    SharedPermission.getAllFriends(self) {
      (pUsers, error) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(friends: nil, error: errorMessage)
      } else {
        if let pUsers = pUsers as? [User] {
          let uniqueFriends = HubModel.removeDuplicates(pUsers)
          completion(friends: uniqueFriends, error: nil)
        }
      }
    }
  }
  
  /* Get all contacts that a friend has shared with me */
  // TODO: See if the query can be built in shared permission itself
  func getAllSharedContacts(friend: User?, completion: (contacts: [Contact]?, error: String?) -> Void) {
    if let friend = friend {
      let query = PFQuery(className: "SharedPermission")
      query.whereKey("user", equalTo: friend)
      query.whereKey("userFriend", equalTo: self)
      query.whereKey("status", equalTo: "accepted")
      query.includeKey("contacts")
      
      SharedPermission.getSharedContacts(query) {
        (pContacts: [PFObject]?, error: NSError?) in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(contacts: nil, error: errorMessage)
        } else if let pContacts = pContacts as? [Contact] {
          completion(contacts: pContacts, error: nil)
        }
      }
    }
  }
  
  // Get contacts I shared with a friend
  // TODO: See if the query can be built in shared permission itself
  func getContactsIShared(friend: User?, completion: (contacts: [Contact]?, error: String?) -> Void) {
    if let friend = friend {
      let query = PFQuery(className: "SharedPermission")
      query.whereKey("userFriend", equalTo: friend)
      query.whereKey("user", equalTo: self)
      query.whereKey("status", equalTo: "accepted")
      query.includeKey("contacts")
      
      SharedPermission.getSharedContacts(query) {
        (pContacts: [PFObject]?, error: NSError?) in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(contacts: nil, error: errorMessage)
        } else if let pContacts = pContacts as? [Contact] {
          completion(contacts: pContacts, error: nil)
        }
      }
    }
  }
  
  //Get my own contacts
  // TODO: Use PFUser.query() to get the contacts.
  func getContacts(completion: (contacts: [Contact]?, error: String?) -> Void) {
    let contactsGroup = dispatch_group_create()
    var fetchedContacts = [Contact]()
    for pObject in contacts {
      dispatch_group_enter(contactsGroup)
      pObject.fetchInBackgroundWithBlock {
        (pContact: PFObject?, error: NSError?) -> Void in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(contacts: nil, error: errorMessage)
        } else if let pContact = pContact as? Contact {
          fetchedContacts.append(pContact)
        }
        dispatch_group_leave(contactsGroup)
      }
    }
    dispatch_group_notify(contactsGroup, dispatch_get_main_queue()) {
      self.contacts = fetchedContacts
      completion(contacts: fetchedContacts, error: nil)
    }
  }
  
  //Get a list of friends that asked to connect with me
  // TODO: See if the query can be built in shared permission itself
  func getRequests(completion: (requests: [User]?, error: String?) -> Void) {
    let query = PFQuery(className: "SharedPermission")
    query.whereKey("userFriend", equalTo: self)
    query.whereKey("status", equalTo: "pending")
    query.includeKey("user")
    
    SharedPermission.getRequests(query) {
      (pRequests: [PFUser]?, error: NSError?) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(requests: nil, error: errorMessage)
      } else if let pRequests = pRequests {
        var requests = [User]()
        for pRequest in pRequests {
          let request = pRequest as? User
          requests.append(request!)
        }
        completion(requests: requests, error: nil)
      }
    }
  }
  
  /* Update contacts for a user when the user update them. Also will remove
   * the deleted/ empty contacts from parse for the user */
  func setContacts(contacts: [Contact], completion: (Bool, String?) -> Void) {
    self.contacts = contactsToSaveArray(contacts)
    let contactsToDelete = contactsToDeleteArray(contacts)
    
    self.saveUser { (success, error) in
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
        completion(false, error)
      }
    }
  }
  
  func acceptRequest(friend: User?, completion: (Bool, String?) -> Void) {
    if let friend = friend {
      let query = PFQuery(className: "SharedPermission")
      query.whereKey("userFriend", equalTo: self)
      query.whereKey("user", equalTo: friend)
      
      let pushQuery = PFInstallation.query()!
      pushQuery.whereKey("user", equalTo: friend)
      let message = "\(self.firstName) \(self.lastName) accepted your request to connect"
      let push = PFPush()
      push.setQuery(pushQuery)
      let data = [ "alert": message, "badge": "Increment", "sound": "Ambient Hit.mp3" ]
      push.setData(data)
      
      SharedPermission.acceptRequest(query) {
        (success: Bool, error: NSError?) in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(false, errorMessage)
        } else if success {
          push.sendPushInBackground()
          completion(true, nil)
        }
      }
    }
  }
  
  func declineRequest(friend: User?) {
    if let friend = friend {
      let query = PFQuery(className: "SharedPermission")
      query.whereKey("userFriend", equalTo: self)
      query.whereKey("user", equalTo: friend)
      query.whereKey("status", equalTo: "pending")
      
      query.getFirstObjectInBackgroundWithBlock {
        (sharedPermission: PFObject?, error: NSError?) in
        sharedPermission?.deleteInBackground()
      }
    }
  }
  
  func deleteAccount(completion: (success: Bool, error: String?) -> Void) {
    self.deleteInBackgroundWithBlock {
      (success: Bool, error: NSError?) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(success: false, error: errorMessage)
      } else if success {
        PFUser.logOut()
        completion(success: true, error: nil)
      }
    }
  }
  
  func searchForFriends(textToSearch: String, completion: ([User]?, String?) -> Void) {
    if let query = PFUser.query() {
      query.whereKey("firstName", hasPrefix: textToSearch)
      query.whereKey("profileIsVisible", equalTo: true)
      query.whereKey("objectId", notEqualTo: objectId!)
      
      HubAPI.searchUsers(query, completion: {
        (pUsers, error) in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(nil, errorMessage)
        } else if let pUsers = pUsers {
          var users = [User]()
          for pUser in pUsers {
            let user = pUser as? User
            users.append(user!)
          }
          completion(users, nil)
        }
      })
    }
  }
  
  class func resetPassword(email: String?, completion: (success: Bool, error: String?) -> Void) {
    if let email = email {
      self.requestPasswordResetForEmailInBackground(email) {
        (success: Bool, error: NSError?) -> Void in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(success: false, error: errorMessage)
        } else {
          completion(success: true, error: nil)
        }
      }
    }
  }
  
  func saveUser(completion: (success: Bool, error: String?) -> Void) {
    self.saveInBackgroundWithBlock {
      (success: Bool, error: NSError?) in
      if let error = error {
        let errorMessage = error.userInfo["error"] as? String
        completion(success: success, error: errorMessage)
      } else {
        completion(success: success, error: nil)
      }
    }
  }
  
  func isFriendsWith(user: User?, completion: (Bool) -> Void) {
    if let user = user {
      let query = PFQuery(className: "SharedPermission")
      query.whereKey("userFriend", equalTo: user)
      query.whereKey("user", equalTo: self)
      
      query.getFirstObjectInBackgroundWithBlock {
        (pObject: PFObject?, error: NSError?) in
        if pObject == nil {
          completion(false)
        } else {
          completion(true)
        }
      }
    }
  }
  
  func unfriend(friend: User) {
    let query1 = PFQuery(className: "SharedPermission")
    query1.whereKey("userFriend", equalTo: friend)
    query1.whereKey("user", equalTo: self)
    query1.whereKey("status", equalTo: "accepted")
    
    let query2 = PFQuery(className: "SharedPermission")
    query2.whereKey("userFriend", equalTo: self)
    query2.whereKey("user", equalTo: friend)
    query2.whereKey("status", equalTo: "accepted")
    
    let mainQuery = PFQuery.orQueryWithSubqueries([query1, query2])
    
    mainQuery.findObjectsInBackgroundWithBlock {
      (sharedPermissions: [PFObject]?, error: NSError?) in
      if let sharedPermissions = sharedPermissions {
        for sharedPermission in sharedPermissions {
          sharedPermission.deleteInBackground()
        }
      }
    }
  }
  
  //---------------------Private methods-----------------------------
  
  /* If the contact value is empty after a user update his contacts those contacts
   * will be deleted from parse */
  private func contactsToDeleteArray(contacts: [Contact]) -> [Contact] {
    var returnArray = [Contact]()
    for contact in contacts {
      if contact.value == "" {
        returnArray.append(contact)
      }
    }
    return returnArray
  }
  
  private func contactsToSaveArray(contacts: [Contact]) -> [Contact] {
    var returnArray = [Contact]()
    self.contacts.removeAll()
    for contact in contacts {
      if contact.value != "" {
        returnArray.append(contact)
      }
    }
    return returnArray
  }
}
