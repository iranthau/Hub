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
    var uniqueArray = [User]()
    if let user = array.first {
      uniqueArray.append(user)
    }
    for o1 in array {
      for o2 in uniqueArray {
        if o1.objectId != o2.objectId {
          uniqueArray.append(o1)
        }
      }
    }
    return uniqueArray
  }
}