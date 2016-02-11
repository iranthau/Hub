//
//  ContactType.swift
//  Hub
//
//  Created by Alexei Gudimenko on 9/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation

enum ContactType: Int {
    
    case Home = 1, Work, Mobile, Other, Facebook, LinkedIn, Viber, Twitter, Instagram,
        Pinterest, LastFM, DeviantArt, Google, Whatsapp, Snapchat, Steam, VK, School,
        Skype, Line, DefaultPhone, DefaultEmail, DefaultAddress, DefaultSocial
    
    init()
    {
        self = .Home
    }
    
    init?(number: Int)
    {
        switch number
        {
        case 1: self = .Home
        case 2: self = .Work
        case 3: self = .Mobile
        case 4: self = .Other
        case 5: self = .Facebook
        case 6: self = .LinkedIn
        case 7: self = .Viber
        case 8: self = .Twitter
        case 9: self = .Instagram
        case 10: self = .Pinterest
        case 11: self = .LastFM
        case 12: self = .DeviantArt
        case 13: self = .Google
        case 14: self = .Whatsapp
        case 15: self = .Snapchat
        case 16: self = .Steam
        case 17: self = .VK
        case 18: self = .School
        case 19: self = .Skype
        case 20: self = .Line
        case 21: self = .DefaultPhone
        case 22: self = .DefaultEmail
        case 23: self = .DefaultAddress
        case 24: self = .DefaultSocial
        default: self = .Home
        }
    }
    
    var name:String {
        switch self {
        case .Home: return "home"
        case .Work: return "work"
        case .Mobile: return "mobile"
        case .School: return "school"
        case .Other: return "other"
        case .Facebook: return "facebook"
        case .LinkedIn: return "linkedin"
        case .Viber: return "viber"
        case .Twitter: return "twitter"
        case .Instagram: return "instagram"
        case .Pinterest: return "pinterest"
        case .LastFM: return "lastfm"
        case .DeviantArt: return "deviantart"
        case .Google: return "google"
        case .Whatsapp: return "whatsapp"
        case .Snapchat: return "snapchat"
        case .Steam: return "steam"
        case .VK: return "vk"
        case .Skype: return "skype"
        case .Line: return "line"
        case .DefaultPhone: return "phone"
        case .DefaultEmail: return "email"
        case .DefaultAddress: return "address"
        case .DefaultSocial: return "social"
        }
    }
    
    var imageForContactType:String {
        get {
           return self.name
        }
    }
}