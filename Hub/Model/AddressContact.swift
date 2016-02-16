//
//  AddressContact.swift
//  Hub
//
//  Created by Alexei Gudimenko on 15/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

struct AddressContact {
    
    var type: ContactType = .DefaultAddress
    var value: String = ""
    var image: UIImage = UIImage(named: "address-other")!
}