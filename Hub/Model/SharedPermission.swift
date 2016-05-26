//  SharedPermission.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import Parse

class SharedPermission: PFObject, PFSubclassing {
    @NSManaged var user: User?
    @NSManaged var userFriend: User?
    @NSManaged var status: String
    @NSManaged var contacts: [Contact]
    
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
        return "SharedPermission"
    }
    
    convenience init(fromUser: User, toUser: User, contacts: [Contact], status: String) {
        self.init()
        user = fromUser
        userFriend = toUser
        self.contacts = contacts
        self.status = status
    }
    
    func sendRequest(pushNotification: PFPush?, completion: (success: Bool, error: String?) -> Void) {
        if let pushNotification = pushNotification {
            HubAPI.saveParseObject(self, completion: {
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
            let query = PFQuery(className: "SharedPermission")
            query.whereKey("userFriend", equalTo: userFriend!)
            query.whereKey("user", equalTo: user!)
            query.whereKey("status", equalTo: "accepted")
            
            HubAPI.updateContacts(query, pContacts: contacts, completion: {
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
    
    class func buildFriendQuery(fieldToMatch: String, objectForTheField: PFUser) -> PFQuery {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey(fieldToMatch, equalTo: objectForTheField)
        query.whereKey("status", equalTo: "accepted")
        return query
    }
}