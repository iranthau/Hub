//  Contact.swift
//  Hub
//  Created by Alexei Gudimenko on 22/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

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
    
    func buildParseContact() {
        updateParseObjectField("value", value: value)
        updateParseObjectField("type", value: type)
        updateParseObjectField("subType", value: subType)
    }
    
    func setObjectId() {
        if let objectId = objectId {
            matchingParseObject.objectId = objectId
        }
    }
    
    func getImageName() -> String {
        switch type! {
            case ContactType.Phone.label:
                return getPhoneImageIconName()
            case ContactType.Email.label:
                return getEmailImageIconName()
            case ContactType.Address.label:
                return getAddressImageIconName()
            case ContactType.Social.label:
                return getSocialImageIcon()
            default: return ""
        }
    }
    
    //-----------------------Private methods--------------------------
    
    private func updateParseObjectField(attribute: String, value: String?) {
        if let value = value {
            matchingParseObject[attribute] = value
        }
    }
    
    private func getPhoneImageIconName() -> String {
        switch subType! {
            case ContactSubType.PhoneHome.label:
                return ContactSubType.PhoneHome.image
            case ContactSubType.PhoneWork.label:
                return ContactSubType.PhoneWork.image
            case ContactSubType.PhoneOther.label:
                return ContactSubType.PhoneOther.image
            case ContactSubType.PhonePersonal.label:
                return ContactSubType.PhonePersonal.image
            default: return ""
        }
    }
    
    private func getEmailImageIconName() -> String {
        switch subType! {
            case ContactSubType.EmailHome.label:
                return ContactSubType.EmailHome.image
            case ContactSubType.EmailWork.label:
                return ContactSubType.EmailWork.image
            case ContactSubType.EmailOther.label:
                return ContactSubType.EmailOther.image
            case ContactSubType.EmailSchool.label:
                return ContactSubType.EmailSchool.image
            default: return ""
        }
    }
    
    private func getAddressImageIconName() -> String {
        switch subType! {
            case ContactSubType.AddressHome.label:
                return ContactSubType.AddressHome.image
            case ContactSubType.AddressWork.label:
                return ContactSubType.AddressWork.image
            case ContactSubType.AddressOther.label:
                return ContactSubType.AddressOther.image
            case ContactSubType.AddressSchool.label:
                return ContactSubType.AddressSchool.image
            default: return ""
        }
    }
    
    private func getSocialImageIcon() -> String {
        switch subType! {
            case ContactSubType.Facebook.label:
                return ContactSubType.Facebook.image
            case ContactSubType.Twitter.label:
                return ContactSubType.Twitter.image
            case ContactSubType.LinkedIn.label:
                return ContactSubType.LinkedIn.image
            case ContactSubType.Skype.label:
                return ContactSubType.Skype.image
            case ContactSubType.Whatsapp.label:
                return ContactSubType.Whatsapp.image
            case ContactSubType.Viber.label:
                return ContactSubType.Viber.image
            case ContactSubType.Line.label:
                return ContactSubType.Line.image
            case ContactSubType.Snapchat.label:
                return ContactSubType.Snapchat.image
            case ContactSubType.Instagram.label:
                return ContactSubType.Instagram.image
            case ContactSubType.Tumblr.label:
                return ContactSubType.Tumblr.image
            case ContactSubType.SocialOther.label:
                return ContactSubType.SocialOther.image
            default: return ""
        }
    }
}