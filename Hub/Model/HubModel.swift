//
//  HubModel.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 24/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import UIKit
import Parse

class HubModel {
    
    var currentUser: User?
    
    private init() {
        
    }
    
    private struct Static {
        static var instance: HubModel?
    }
    
    class var sharedInstance: HubModel {
        if !(Static.instance != nil) {
            Static.instance = HubModel()
        }
        return Static.instance!
    }
    
    
}