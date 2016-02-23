//
//  AddressContact.swift
//  Hub
//
//  Created by Alexei Gudimenko on 15/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class AddressContact: Contact {
    
    override init() {
        super.init()
        type = .DefaultAddress
        image = UIImage(named: "address-other")!
    }
}