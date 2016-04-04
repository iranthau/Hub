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
    
    func getImageName() -> String {
        switch subType {
            case ContactSubType.PhoneHome.label: return ContactSubType.PhoneHome.image
            case ContactSubType.PhoneWork.label: return ContactSubType.PhoneWork.image
            case ContactSubType.PhoneOther.label: return ContactSubType.PhoneOther.image
            case ContactSubType.PhonePersonal.label: return ContactSubType.PhonePersonal.image
            
            case ContactSubType.EmailHome.label: return ContactSubType.EmailHome.image
            case ContactSubType.EmailWork.label: return ContactSubType.EmailWork.image
            case ContactSubType.EmailOther.label: return ContactSubType.EmailOther.image
            case ContactSubType.EmailSchool.label: return ContactSubType.EmailSchool.image
            
            case ContactSubType.AddressHome.label: return ContactSubType.AddressHome.image
            case ContactSubType.AddressWork.label: return ContactSubType.AddressWork.image
            case ContactSubType.AddressOther.label: return ContactSubType.AddressOther.image
            case ContactSubType.AddressSchool.label: return ContactSubType.AddressSchool.image
            
            case ContactSubType.Facebook.label: return ContactSubType.Facebook.image
            case ContactSubType.Twitter.label: return ContactSubType.Twitter.image
            case ContactSubType.LinkedIn.label: return ContactSubType.LinkedIn.image
            case ContactSubType.Skype.label: return ContactSubType.Skype.image
            case ContactSubType.Viber.label: return ContactSubType.Viber.image
            case ContactSubType.Line.label: return ContactSubType.Line.image
            case ContactSubType.Snapchat.label: return ContactSubType.Snapchat.image
            case ContactSubType.Instagram.label: return ContactSubType.Instagram.image
            case ContactSubType.Tumblr.label: return ContactSubType.Tumblr.image
            case ContactSubType.SocialOther.label: return ContactSubType.SocialOther.image
            default: return ""
        }
    }
}