//
//  HubModel.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import UIKit
import Parse

class HubModel {
    
    var user: User?
    
    private init() {
        
    }
    
    private struct Static {
        static var instance: HubModel?
    }
    
    class var sharedInstance: HubModel {
        if !(Static.instance != nil) {
            Static.instance = HubModel()
        }
        return Static.instance!
    }
    
    func userSignUp(view: SignUpViewController) {
        let pfUser = PFUser()
        
        pfUser["firstName"] = user!.firstName
        pfUser["lastName"] = user!.lastName
        pfUser.username = user!.email
        pfUser.email = user!.email
        pfUser.password = user!.password
        pfUser["profileImage"] = user!.profileImage
        
        user!.signUp(view, pfUser: pfUser)
    }
    
    func getAllContacts(tableViewController: MyContactsTableViewController) {
        // Temporary code
        let currentUser = PFUser.currentUser()
        self.user = self.pfUserToUser(currentUser!)
        user!.getAllMyContacts(tableViewController, model: self)
    }
    
    func pfUserToUser(pfContact: PFUser) -> User {
        let contact = User(fName: pfContact["firstName"] as! String, lName: pfContact["lastName"] as! String, email: pfContact.username!)
        contact.nickName = pfContact["nickName"] as? String
        contact.cityName = pfContact["city"] as? String
        
        if pfContact["profileImage"] != nil {
            contact.profileImage = pfContact["profileImage"] as! PFFile
        }
        
        return contact
    }
}