//
//  Section.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 14/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation

class Section {
    var users = [User]()
    
    func addUser(user: User) {
        self.users.append(user)
    }
}