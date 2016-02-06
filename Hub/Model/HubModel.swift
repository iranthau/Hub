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
}