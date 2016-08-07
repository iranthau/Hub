//  HubModel.swift
//  Hub
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse

class HubModel {
  
  var currentUser: User?
  
  private struct Static {
    static var instance: HubModel?
  }
  
  class var sharedInstance: HubModel {
    if !(Static.instance != nil) {
      Static.instance = HubModel()
    }
    return Static.instance!
  }
  
  class func removeObject(array: [Contact], object: Contact) -> [Contact] {
    var newArray = [Contact]()
    for o in array {
      if o.objectId != object.objectId {
        newArray.append(o)
      }
    }
    return newArray
  }
  
  class func removeDuplicates(array: [User]) -> [User] {
    var idSet = Set<String>()
    var uniqueArray = [User]()
    for o in array {
      if let id = o.objectId {
        if !idSet.contains(id) {
          idSet.insert(id)
          uniqueArray.append(o)
        }
      }
    }
    return uniqueArray
  }
}