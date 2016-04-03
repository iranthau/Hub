//
//  ContactType.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 2/04/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation

enum ContactType: Int {
    case Phone = 1, Email, Address, Social
    
    init?(number: Int) {
        switch number {
            case 1: self = .Phone
            case 2: self = .Email
            case 3: self = .Address
            case 4: self = .Social
            default: self = .Phone
        }
    }
    
    var label: String {
        switch self {
            case .Phone: return "phone"
            case .Email: return "email"
            case .Address: return "address"
            case .Social: return "social"
        }
    }
}