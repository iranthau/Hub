//  HubAPI.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/05/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse
import ParseFacebookUtilsV4

class HubAPI {
    typealias logInresultObject = (PFUser?, NSError?) -> Void
    
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
}