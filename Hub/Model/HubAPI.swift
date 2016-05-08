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
    
    class func logIn(userDetails: [String: String], completion: authResponse) {
        let username = userDetails["username"]!
        let password = userDetails["password"]!
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let currentUser = PFUser.currentUser()
                completion(currentUser, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
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
    
    class func signUp(pUser: PFUser?, completion: authResponse) {
        if let pUser = pUser {
            pUser.signUpInBackgroundWithBlock {
                (success: Bool, error: NSError?) in
                if let error = error {
                    completion(nil, error)
                } else {
                    let curretUser = PFUser.currentUser()
                    completion(curretUser, nil)
                }
            }
        }
    }
    
    class func logOut(completion: (error: NSError?) -> Void) {
        PFUser.logOutInBackgroundWithBlock {
            (error: NSError?) in
            if let error = error {
                completion(error: error)
            } else {
                completion(error: nil)
            }
        }
    }
    
//    class func getAllFriends(pUser: PFUser?, query: PFQuery?, completion: (pUsers: [PFUser]?, error: NSError?) -> Void) {
//        if let query = query {
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [PFObject]?, error: NSError?) in
//                if let error = error {
//                    completion(pUsers: nil, error: error)
//                } else {
//                    var friends = [PFUser]()
//                    for object in objects! {
//                        let friend = self.getMatchingUser(pUser, sPObject: object)
//                        friends.append(friend!)
//                    }
//                    completion(pUsers: friends, error: nil)
//                }
//            }
//        }
//    }
    
    //---------------------Private methods-----------------------------
//    class func fetchObjects(pUser: PFUser?, objects: [PFUser]?, completion: (pUsers: [PFUser]?, error: NSError?) -> Void) {
//        var friends = [PFUser]()
//        let fetchGroup = dispatch_group_create()
//        if let objects = objects {
//            for object in objects {
//                dispatch_group_enter(fetchGroup)
//                let friend = self.getMatchingUser(pUser, sPObject: object)
//                friend?.fetchInBackgroundWithBlock {
//                    (fetchedFriend: PFObject?, error: NSError?) in
//                    if let error = error {
//                        completion(pUsers: nil, error: error)
//                    } else {
//                        friends.append(fetchedFriend as! PFUser)
//                    }
//                    dispatch_group_leave(fetchGroup)
//                }
//            }
//            dispatch_group_notify(fetchGroup, dispatch_get_main_queue()) {
//                completion(pUsers: friends, error: nil)
//            }
//        }
//    }
//    
//    private class func getMatchingUser(curretUser: PFUser?, sPObject: PFObject?) -> PFUser? {
//        var user: PFUser?
//        if let sPObject = sPObject {
//            let fromUser = sPObject["userFriend"] as! PFUser
//            let toUser = sPObject["user"] as! PFUser
//            if let curretUser = curretUser {
//                if fromUser.objectId == curretUser.objectId! {
//                    user = sPObject["user"] as? PFUser
//                }
//                
//                if toUser.objectId == curretUser.objectId! {
//                    user = sPObject["userFriend"] as? PFUser
//                }
//            }
//        }
//        return user
//    }
    
    /* Read the profile picture data from facebook when given the user ID */
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