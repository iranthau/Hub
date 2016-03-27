//
//  UserFriends.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 27/03/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class UserFriends {
    var userFriendID:   String?
    var userID:         String?
    var friendID:       String?
    var status:         Bool?
    
    init(user_id: String, friend_id: String, status: Bool) {
        userID = user_id
        friendID = friend_id
        self.status = status
    }
}

