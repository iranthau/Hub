//  HubAPI.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/05/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse
import ParseFacebookUtilsV4

class HubAPI {
    typealias logInresultObject = (PFUser?, NSError?) -> Void
    typealias facebookProfileResponse = (NSDictionary?, NSError?) -> Void
    
    class func logIn(userDetails: [String: String], completion: logInresultObject) {
        let username = userDetails["username"]!
        let password = userDetails["password"]!
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let currentUser = PFUser.currentUser()!
                completion(currentUser, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func logInWithFacebook(completion: logInresultObject) {
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
    
    /* Read the profile picture data from facebook when given the user ID */
    class func getProfileImageFromFacebook(id: String?, completion: (image: UIImage?, error: NSError?) -> Void) {
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