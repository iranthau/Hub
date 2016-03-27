//
//  User.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 6/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class User: Hashable {
    var userID:         String
    var firstName:      String
    var lastName:       String
    var email:          String
    var profileImage:   PFFile
    var password:       String?
    var nickName:       String?
    var cityName:       String?
    
    var hashValue: Int {
        return email.hashValue
    }
    
    init(fName: String, lName: String, email: String) {
        userID = "fO0139zWuu"
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
    
    func getAllMyContacts(tableViewController: MyContactsTableViewController, model: HubModel) {
        
        let query = PFQuery(className: "UserFriends")
        
        query.whereKey("userId", equalTo: self.userID)
        query.whereKey("status", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]? , error: NSError?) -> Void in
            
            if error == nil {
                let innerQuery = PFUser.query()
                var friendIds = [String]()
                
                if let objects = objects {
                    for object in objects {
                        friendIds.append(object["friendId"] as! String)
                    }
                    innerQuery!.whereKey("objectId", containedIn: friendIds)
                    
                    innerQuery!.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        var myContacts = [User]()
                        for userObject in objects as! [PFUser] {
                            myContacts.append(model.pfUserToUser(userObject))
                        }
                        tableViewController.myContacts = myContacts.sort { $0.firstName < $1.firstName }
                        tableViewController.refreshTableViewInBackground()

                    }
                }
            }
        }
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}