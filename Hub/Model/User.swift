//
//  User.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 20/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse


class User {
    
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    
    init(firstName: String, lastName: String, email: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    // Handles user signing up
    func signUp(pfUser: PFUser) {
        pfUser.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.userInfo["error"] as? NSString)
            } else {
                print("Success")
            }
        }
    }
    
    // Handles user log in
    func logIn() {
        
    }
    
    // Handles password recovery
    func recoverPassword() {
        
    }
    
    // Handles signing in with facebook
    func signInWithFacebook() {
        
    }
    
    // Retrieve profile information for the current user
    func getProfileInfo() {
        
    }
    
    // Retrieve a list of all friends
    func getFriendsList() {
        
    }
    
    // Retrive a list of friend requests
    func getAllRequests() {
        
    }
}
