//  SharedPermission.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse

class SharedPermission {
    let parseClassName = "SharedPermission"
    let matchingParseObject: PFObject
    var objectId: String?
    var user: User?
    var userFriend: User?
    var status: Bool?
    
    init(parseObject: PFObject) {
        matchingParseObject = parseObject
    }
    
    func buildSharedPermission() {
        objectId = matchingParseObject.objectId
        user = getUserObject("user")
        userFriend = getUserObject("userFriend")
        status = matchingParseObject["status"] as? Bool
    }
    
    func buildParseObject(fromUser: PFUser, toUser: PFUser, contacts: [PFObject], status: String) {
        matchingParseObject["user"] = fromUser
        matchingParseObject["userFriend"] = toUser
        matchingParseObject["contacts"] = contacts
        matchingParseObject["status"] = status
    }
    
    func saveInParse(pushNotification: PFPush, vc: BaseViewController) {
        matchingParseObject.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                pushNotification.sendPushInBackground()
                vc.showAlert("Request is sent")
                vc.disableUIBarbutton()
            }
        }
    }
    
    func buildFriendQuery(fieldToMatch: String, objectForTheField: PFUser) -> PFQuery {
        let query = PFQuery(className: parseClassName)
        query.whereKey(fieldToMatch, equalTo: objectForTheField)
        query.whereKey("status", equalTo: "accepted")
        return query
    }
    
    //---------------------Private methods----------------------
    private func getUserObject(attribute: String) -> User {
        let user = matchingParseObject[attribute] as! PFUser
        let fromUser = User(parseUser: user)
        fromUser.buildUser()
        return fromUser
    }
}