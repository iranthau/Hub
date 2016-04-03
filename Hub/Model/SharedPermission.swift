//
//  SharedPermission.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 3/04/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class SharedPermission {
    let parseClassName = "SharedPermission"
    var objectId: String?
    var user: User
    var contact: Contact
    var userFriend: User
    
    init(user: User, contact: Contact, userFriend: User) {
        self.user = user
        self.contact = contact
        self.userFriend = userFriend
    }
}