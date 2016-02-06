//
//  User.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 6/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class User {
    var firstName: String
    var lastName: String
    var email: String
    var profileImage: PFFile
    var password: String?
    
    init(fName: String, lName: String, email: String) {
        firstName = fName
        lastName = lName
        self.email = email
        let defaultImage = UIImage(named: "placeholder-image")
        let profileImageData = UIImagePNGRepresentation(defaultImage!)
        profileImage = PFFile(data: profileImageData!)!
    }
    
    func getProfileImage() -> UIImage? {
        var image: UIImage?
        
        do {
            image = try UIImage(data: self.profileImage.getData())
        } catch {
            print(error)
        }
        
        return image!
    }
    
    func signUp(view: SignUpViewController, pfUser: PFUser) {
        pfUser.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) in
            if let error = error {
                view.activityIndicator.stopAnimating()
                let errorMessage = error.userInfo["error"] as? String
                view.showAlert(errorMessage!)
            } else {
                view.activityIndicator.stopAnimating()
                view.performSegueWithIdentifier("signUpSegue", sender: nil)
            }
        }
    }
}