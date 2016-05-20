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
    
    func buildParseObject(fromUser: User?, toUser: User?, contacts: [Contact]?, status: String?) {
        if let fromUser = fromUser {
            matchingParseObject["user"] = fromUser.matchingParseObject
        }
        if let toUser = toUser {
            matchingParseObject["userFriend"] = toUser.matchingParseObject
        }
        if let contacts = contacts {
            var pContacts = [PFObject]()
            for c in contacts {
                pContacts.append(c.matchingParseObject)
            }
            matchingParseObject["contacts"] = pContacts
        }
        if let status = status {
            matchingParseObject["status"] = status
        }
    }
    
    func sendRequest(pushNotification: PFPush?, completion: (success: Bool, error: String?) -> Void) {
        if let pushNotification = pushNotification {
            HubAPI.saveParseObject(matchingParseObject, completion: {
                (success: Bool, error: NSError?) in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as? String
                    completion(success: false, error: errorMessage)
                }
                if success {
                    pushNotification.sendPushInBackground()
                    completion(success: true, error: nil)
                }
            })
        }
    }
    
    func updateSharedContacts(pushNotification: PFPush?, completion: (success: Bool, error: String?) -> Void) {
        if let pushNotification = pushNotification {
            let query = PFQuery(className: parseClassName)
            query.whereKey("userFriend", equalTo: matchingParseObject["userFriend"])
            query.whereKey("user", equalTo: matchingParseObject["user"])
            query.whereKey("status", equalTo: "accepted")
            
            HubAPI.updateContacts(query, pContacts: matchingParseObject["contacts"] as? [PFObject], completion: {
                (success: Bool, error: NSError?) in
                if let error = error {
                    let errorMessage = error.userInfo["error"] as? String
                    completion(success: false, error: errorMessage)
                }
                if success {
                    pushNotification.sendPushInBackground()
                    completion(success: true, error: nil)
                }
            })
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