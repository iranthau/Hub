//  HubAPI.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/05/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse
import ParseFacebookUtilsV4

class HubAPI {
  typealias authResponse = (PFUser?, NSError?) -> Void
  typealias facebookProfileResponse = (NSDictionary?, NSError?) -> Void
  
  class func logInWithFacebook(completion: authResponse) {
    PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"]) {
      (user: PFUser?, error: NSError?) -> Void in
      if error != nil {
        completion(nil, error)
      } else {
        completion(user, nil)
      }
    }
  }
  
  class func readFacebookPublicProfile(completion: facebookProfileResponse) {
    let requestParameters = ["fields": "id, email, first_name, last_name"]
    let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
    
    userDetails.startWithCompletionHandler {
      (connection, result, error) -> Void in
      if let error = error {
        completion(nil, error)
      } else {
        let userId = result["id"]! as? String
        var resultDictionary = result as! [String : AnyObject]
        self.getProfileImageFromFacebook(userId, completion: {
          (image, error) in
          if let error = error {
            completion(nil, error)
          } else {
            resultDictionary["profile-image"] = image
            completion(resultDictionary, nil)
          }
        })
      }
    }
  }
  
  //Mark: Can be placed in the cloud code
  class func getAllFriends(pUser: PFUser?, query: PFQuery?, completion: (pUsers: [PFUser]?, error: NSError?) -> Void) {
    if let query = query {
      query.findObjectsInBackgroundWithBlock {
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
  
  class func getSharedContacts(query: PFQuery?, completion: ([PFObject]?, NSError?) -> Void) {
    if let query = query {
      query.getFirstObjectInBackgroundWithBlock {
        (sharedPermission: PFObject?, error: NSError?) -> Void in
        if let error = error {
          completion(nil, error)
        } else if let sharedPermission = sharedPermission {
          let contacts = sharedPermission.objectForKey("contacts") as? [PFObject]
          completion(contacts, nil)
        }
      }
    }
  }
  
  class func updateContacts(query: PFQuery?, pContacts: [PFObject]?, completion: (Bool, NSError?) -> Void) {
    if let query = query {
      query.getFirstObjectInBackgroundWithBlock {
        (sharedPermission: PFObject?, error: NSError?) in
        if let error = error {
          completion(false, error)
        } else if let sharedPermission = sharedPermission {
          sharedPermission["contacts"] = pContacts
          sharedPermission.saveInBackground()
          completion(true, nil)
        }
      }
    }
  }
  
  class func getRequests(query: PFQuery?, completion: ([PFUser]?, NSError?) -> Void) {
    if let query = query {
      query.findObjectsInBackgroundWithBlock {
        (pRequests: [PFObject]?, error: NSError?) in
        if let error = error {
          completion(nil, error)
        } else if let pRequests = pRequests {
          var requests = [PFUser]()
          for pRequest in pRequests {
            let request = pRequest["user"] as? PFUser
            if let request = request {
              requests.append(request)
            }
          }
          completion(requests, nil)
        }
      }
    }
  }
  
  class func saveParseObject(object: PFObject?, completion: (Bool, NSError?) -> Void) {
    if let object = object {
      object.saveInBackgroundWithBlock {
        (success, error) -> Void in
        if let error = error {
          completion(false, error)
        } else if success {
          completion(true, nil)
        }
      }
    }
  }
  
  //Mark: Can be placed in the cloud code
  class func deleteABatchOfObjects(objects: [PFObject]?, completion: (success: Bool, error: NSError?) -> Void) {
    if let objects = objects {
      let deleteGroup = dispatch_group_create()
      for object in objects {
        dispatch_group_enter(deleteGroup)
        object.deleteInBackgroundWithBlock {
          (success: Bool, error: NSError?) in
          if success == false {
            completion(success: success, error: error)
          }
          dispatch_group_leave(deleteGroup)
        }
      }
      dispatch_group_notify(deleteGroup, dispatch_get_main_queue()) {
        completion(success: true, error: nil)
      }
    }
  }
  
  //Mark: Can be placed in the cloud code
  class func acceptRequest(query: PFQuery?, completion: (Bool, NSError?) -> Void) {
    if let query = query {
      query.getFirstObjectInBackgroundWithBlock {
        (sharedPermission: PFObject?, error: NSError?) in
        if let error = error {
          completion(false, error)
        } else if let sharedPermission = sharedPermission {
          sharedPermission["status"] = "accepted"
          sharedPermission.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) in
            if success {
              completion(true, nil)
            } else if let error = error {
              completion(false, error)
            }
          }
        }
      }
    }
  }
  
  class func searchUsers(query: PFQuery?, completion: (pUsers: [PFUser]?, error: NSError?) -> Void) {
    if let query = query {
      query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if let error = error {
          completion(pUsers: nil, error: error)
        } else if let objects = objects {
          completion(pUsers: objects as? [PFUser], error: nil)
        }
      }
    }
  }
  
  class func recoverPassword(email: String?, completion: (success: Bool, error: NSError?) -> Void) {
    if let email = email {
      PFUser.requestPasswordResetForEmailInBackground(email) {
        (success: Bool, error: NSError?) -> Void in
        if let error = error {
          completion(success: false, error: error)
        } else {
          completion(success: true, error: nil)
        }
      }
    }
  }
  
  class func registerForPushNotification() {
    let installation = PFInstallation.currentInstallation()
    if PFUser.currentUser() != nil {
      installation["user"] = PFUser.currentUser()
    }
    installation.saveInBackground()
  }
  
  class func isFriends(query: PFQuery?, completion: (Bool) -> Void) {
    if let query = query {
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
  
  /* Read the profile picture data from facebook when given the user ID */
  //Mark: Can be placed in the cloud code
  private class func getProfileImageFromFacebook(id: String?, completion: (image: UIImage?, error: NSError?) -> Void) {
    if let id = id {
      let userProfileUrl = "https://graph.facebook.com/\(id)/picture?type=large"
      let profilePictureUrl = NSURL(string: userProfileUrl)!
      let profilePicturedata = NSData(contentsOfURL: profilePictureUrl)
      
      if let profilePicturedata = profilePicturedata {
        let profileImage = UIImage(data: profilePicturedata)!
        completion(image: profileImage, error: nil)
      } else {
        let error = NSError(domain: "Facebook profile image", code: 1, userInfo: ["error": "Could not read the image from facebook"])
        completion(image: nil, error: error)
      }
    }
  }
}