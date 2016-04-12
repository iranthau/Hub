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
    var objectId: String?
    var value: String?
    var type: String?
    var subType: String?
    var selected: Bool?
    
    init(parseObject: PFObject) {
        matchingParseObject = parseObject
    }
    
    func buildContact() {
        objectId = matchingParseObject.objectId!
        value = matchingParseObject["value"] as? String
        type = matchingParseObject["type"] as? String
        subType = matchingParseObject["subType"] as? String
        selected = false
    }
    
    func buildParseObject(value: String, type: String, subType: String) {
        matchingParseObject = PFObject(className: parseClassName)
        matchingParseObject["value"] = value
        matchingParseObject["type"] = type
        matchingParseObject["subType"] = subType
    }
    
    func getImageName() -> String {
        let contactType = (type!, subType!)
        switch contactType {
            case (ContactType.Phone.label, ContactSubType.PhoneHome.label):
                return ContactSubType.PhoneHome.image
            case (ContactType.Phone.label, ContactSubType.PhoneWork.label):
                return ContactSubType.PhoneWork.image
            case (ContactType.Phone.label, ContactSubType.PhoneOther.label):
                return ContactSubType.PhoneOther.image
            case (_, ContactSubType.PhonePersonal.label):
                return ContactSubType.PhonePersonal.image
            
            case (ContactType.Email.label, ContactSubType.EmailHome.label):
                return ContactSubType.EmailHome.image
            case (ContactType.Email.label, ContactSubType.EmailWork.label):
                return ContactSubType.EmailWork.image
            case (ContactType.Email.label, ContactSubType.EmailOther.label):
                return ContactSubType.EmailOther.image
            case (ContactType.Email.label, ContactSubType.EmailSchool.label):
                return ContactSubType.EmailSchool.image
            
            case (ContactType.Address.label, ContactSubType.AddressHome.label):
                return ContactSubType.AddressHome.image
            case (ContactType.Address.label, ContactSubType.AddressWork.label):
                return ContactSubType.AddressWork.image
            case (ContactType.Address.label, ContactSubType.AddressOther.label):
                return ContactSubType.AddressOther.image
            case (ContactType.Address.label, ContactSubType.AddressSchool.label):
                return ContactSubType.AddressSchool.image
            
            case (_, ContactSubType.Facebook.label):
                return ContactSubType.Facebook.image
            case (_, ContactSubType.Twitter.label):
                return ContactSubType.Twitter.image
            case (_, ContactSubType.LinkedIn.label):
                return ContactSubType.LinkedIn.image
            case (_, ContactSubType.Skype.label):
                return ContactSubType.Skype.image
            case (_, ContactSubType.Viber.label):
                return ContactSubType.Viber.image
            case (_, ContactSubType.Line.label):
                return ContactSubType.Line.image
            case (_, ContactSubType.Snapchat.label):
                return ContactSubType.Snapchat.image
            case (_, ContactSubType.Instagram.label):
                return ContactSubType.Instagram.image
            case (_, ContactSubType.Tumblr.label):
                return ContactSubType.Tumblr.image
            case (ContactType.Social.label, ContactSubType.SocialOther.label):
                return ContactSubType.SocialOther.image
            default: return ""
        }
    }
}