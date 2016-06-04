//  Contact.swift
//  Hub
//  Created by Alexei Gudimenko on 22/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse

class Contact: PFObject, PFSubclassing {
  @NSManaged var value: String?
  @NSManaged var type: String?
  @NSManaged var subType: String?
  var selected = false
  
  private override init() {
    super.init()
  }
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "Contact"
  }
  
  convenience init(value: String?, type: String, subType: String) {
    self.init()
    self.value = value
    self.type = type
    self.subType = subType
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