//
//  PhoneContact.swift
//  Hub
//
//  Created by Alexei Gudimenko on 15/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class PhoneContact: Contact {
    
    override init() {
        super.init()
        type = .DefaultPhone
        image = UIImage(named: "phone-other")!
    }
}