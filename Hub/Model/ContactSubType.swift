//  ContactType.swift
//  Hub
//  Created by Alexei Gudimenko on 9/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation

enum ContactSubType: Int {
  
  case PhoneHome = 1, PhoneWork, PhoneOther, PhonePersonal,
  EmailHome, EmailWork, EmailSchool, EmailOther,
  AddressHome, AddressWork, AddressSchool, AddressOther,
  Facebook, Twitter, LinkedIn, Skype, Whatsapp, Viber, Line, Snapchat, Instagram, Tumblr, SocialOther
  
  init?(number: Int) {
    switch number {
    case 1: self = .PhoneHome
    case 2: self = .PhoneWork
    case 3: self = .PhoneOther
    case 4: self = .PhonePersonal
    case 5: self = .EmailHome
    case 6: self = .EmailWork
    case 7: self = .EmailSchool
    case 8: self = .EmailOther
    case 9: self = .AddressHome
    case 10: self = .AddressWork
    case 11: self = .AddressSchool
    case 12: self = .AddressOther
    case 13: self = .Facebook
    case 14: self = .Twitter
    case 15: self = .LinkedIn
    case 16: self = .Skype
    case 17: self = .Whatsapp
    case 18: self = .Viber
    case 19: self = .Line
    case 20: self = .Snapchat
    case 21: self = .Instagram
    case 22: self = .Tumblr
    case 23: self = .SocialOther
    default: self = .PhoneHome
    }
  }
  
  var label: String {
    switch self {
    case .PhoneHome, .EmailHome, .AddressHome:
      return "home"
    case .PhoneWork, .EmailWork, .AddressWork:
      return "work"
    case .PhoneOther, .EmailOther, .AddressOther:
      return "other"
    case .SocialOther:
      return "website"
    case .PhonePersonal: return "mobile"
    case .EmailSchool, .AddressSchool:
      return "school"
    case .Facebook: return "facebook"
    case .Twitter: return "twitter"
    case .LinkedIn: return "linkedin"
    case .Skype: return "skype"
    case .Whatsapp: return "whatsapp"
    case .Viber: return "viber"
    case .Line: return "line"
    case .Snapchat: return "snapchat"
    case .Instagram: return "instagram"
    case .Tumblr: return "tumblr"
    }
  }
  
  var image: String {
    get {
      switch self{
      case .PhoneHome: return "phone-home"
      case .PhoneWork: return "phone-work"
      case .PhoneOther: return "phone-other"
      case .PhonePersonal: return "phone-personal"
      case .EmailHome: return "email-home"
      case .EmailWork: return "email-work"
      case .EmailOther: return "email-other"
      case .EmailSchool: return "email-school"
      case .AddressHome: return "address-home"
      case .AddressWork: return "address-work"
      case .AddressOther: return "address-other"
      case .AddressSchool: return "address-school"
      case .Facebook: return "facebook"
      case .Twitter: return "twitter"
      case .LinkedIn: return "linkedin"
      case .Skype: return "skype"
      case .Whatsapp: return "whatsapp"
      case .Viber: return "viber"
      case .Line: return "line"
      case .Snapchat: return "snapchat"
      case .Instagram: return "instagram"
      case .Tumblr: return "tumblr"
      case .SocialOther: return "social-other"
      }
    }
  }
}