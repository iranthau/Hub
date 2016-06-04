//  SharedPermission.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse

class SharedPermission: PFObject, PFSubclassing {
  @NSManaged var user: User?
  @NSManaged var userFriend: User?
  @NSManaged var status: String
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
  
  static func parseClassName() -> String {
    return "SharedPermission"
  }
  
  convenience init(fromUser: User, toUser: User, contacts: [Contact], status: String) {
    self.init()
    user = fromUser
    userFriend = toUser
    self.contacts = contacts
    self.status = status
  }
  
  override class func query() -> PFQuery? {
    let query = PFQuery(className: SharedPermission.parseClassName())
    return query
  }
  
  //Mark: Can be placed in the cloud code
  class func getAllFriends(pUser: PFUser?, completion: (pUsers: [PFUser]?, error: NSError?) -> Void) {
    if let pUser = pUser {
      if let subQuery1 = query() {
        if let subQuery2 = query() {
          subQuery1.whereKey("user", equalTo: pUser)
          subQuery1.whereKey("status", equalTo: "accepted")
          
          subQuery2.whereKey("userFriend", equalTo: pUser)
          subQuery2.whereKey("status", equalTo: "accepted")
          
          let mainQuery = PFQuery.orQueryWithSubqueries([subQuery1, subQuery2])
          
          mainQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) in
            if let error = error {
              completion(pUsers: nil, error: error)
            } else {
              fetchFriendsFromIds(pUser, objects: objects, completion: {
                (pUsers, error) in
                if let error = error {
                  completion(pUsers: nil, error: error)
                } else {
                  completion(pUsers: pUsers, error: nil)
                }
              })
            }
          }
        }
      }
    }
  }
  
  func sendRequest(pushNotification: PFPush?, completion: (success: Bool, error: String?) -> Void) {
    if let pushNotification = pushNotification {
      HubAPI.saveParseObject(self, completion: {
        (success: Bool, error: NSError?) in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(success: false, error: errorMessage)
        }
        if success {
          pushNotification.sendPushInBackground()
          completion(success: true, error: nil)
        }
      })
    }
  }
  
  func updateSharedContacts(pushNotification: PFPush?, completion: (success: Bool, error: String?) -> Void) {
    if let pushNotification = pushNotification {
      let query = PFQuery(className: "SharedPermission")
      query.whereKey("userFriend", equalTo: userFriend!)
      query.whereKey("user", equalTo: user!)
      query.whereKey("status", equalTo: "accepted")
      
      HubAPI.updateContacts(query, pContacts: contacts, completion: {
        (success: Bool, error: NSError?) in
        if let error = error {
          let errorMessage = error.userInfo["error"] as? String
          completion(success: false, error: errorMessage)
        }
        if success {
          pushNotification.sendPushInBackground()
          completion(success: true, error: nil)
        }
      })
    }
  }
  
  //---------------------Private methods-----------------------------
  
  //Mark: Can be placed in the cloud code
  private class func fetchFriendsFromIds(pUser: PFUser?, objects: [PFObject]?, completion: (pUsers: [PFUser]?, error: NSError?) -> Void) {
    var friends = [PFUser]()
    let fetchGroup = dispatch_group_create()
    if let objects = objects {
      for object in objects {
        let friend = self.getMatchingUser(pUser, sPObject: object)
        dispatch_group_enter(fetchGroup)
        if let friend = friend {
          friend.fetchInBackgroundWithBlock {
            (fetchedFriend: PFObject?, error: NSError?) in
            if let error = error {
              completion(pUsers: nil, error: error)
            } else {
              friends.append(fetchedFriend as! PFUser)
            }
            dispatch_group_leave(fetchGroup)
          }
        }
      }
      dispatch_group_notify(fetchGroup, dispatch_get_main_queue()) {
        completion(pUsers: friends, error: nil)
      }
    }
  }
  
  //Mark: Can be placed in the cloud code
  private class func getMatchingUser(curretUser: PFUser?, sPObject: PFObject?) -> PFUser? {
    var user: PFUser?
    if let sPObject = sPObject {
      let fromUser = sPObject["userFriend"] as! PFUser
      let toUser = sPObject["user"] as! PFUser
      if let curretUser = curretUser {
        if fromUser.objectId == curretUser.objectId! {
          user = sPObject["user"] as? PFUser
        }
        
        if toUser.objectId == curretUser.objectId! {
          user = sPObject["userFriend"] as? PFUser
        }
      }
    }
    return user
  }
}