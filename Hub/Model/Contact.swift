//
//  Contact.swift
//  Hub
//
//  Created by Alexei Gudimenko on 22/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import Parse

class Contact {
    
    let parseClassName = "Contact"
    var matchingParseObject: PFObject
    var objectId: String
    var value: String
    var type: String
    var subType: String
    
    init(parseObject: PFObject) {
        matchingParseObject = parseObject
        objectId = parseObject.objectId!
        value = parseObject["value"] as! String
        type = parseObject["type"] as! String
        subType = parseObject["subType"] as! String
    }
    
//    init(value: String, type: String, subType: String) {
//        matchingParseObject = PFObject(className: parseClassName)
//        matchingParseObject["value"] = value
//        matchingParseObject["type"] = type
//        matchingParseObject["subType"] = subType
//    }
    
    func save() {
        matchingParseObject.saveInBackground()
    }
}