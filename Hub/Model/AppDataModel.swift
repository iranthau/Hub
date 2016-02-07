//
//  AppDataModel.swift
//  Hub
//
//  Created by Alexei Gudimenko on 2/01/2016 [RENAMED].
//  Copyright © 2016 88Software. All rights reserved.
//
//  This class will hold the basic data model for the app, and keep track of 
//  things such as whether the user has logged into the app for the first time,
//  and so on. This functionality may be rewritten later to use Parse as 
//  back end, but for now the data will just be written to a local file for
//  testing purposes.
//

import Foundation

class AppDataModel {
    
    //Reference to the local user and the shared contacts:
    //var localUserProfile: User
    //var contacts: [User]()
    
    init() {
        //TODO: load any data from persistent storage (file, host or database)
        
        //register the default settings:
        registerDefaults()
        handleFirstTimeLaunch()
    }
    
    //Set default behaviour here. This will be used for any required default setup
    // for when a user installs the app for the first time.
    func registerDefaults() {
        let dictionary = [
            "FirstTimeLaunch": true,
            "TermsConditionsAccepted": false,
            "ProfileShownToPublic": true,
            "UserLoggedIn": false
        ]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    //handle first-time launch, and perform any necessary first-time setup
    func handleFirstTimeLaunch() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTimeLaunch = userDefaults.boolForKey("FirstTimeLaunch")
        
        if firstTimeLaunch {
            //TODO: perform any setup steps
            
            
            //set FirstTimeLaunch flag to false and write the changes to persistent
            // storage:
            userDefaults.setBool(false, forKey: "FirstTimeLaunch")
            userDefaults.synchronize()
        }
    }
    
    //TODO: save-data function here:
    func saveAppData() {
        //set up mechanism for data processing: a data object and the archiver that'll do the writing
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        //encode data and give it a key, this will be the filename and key used on loading the data
        //archiver.encodeObject(    , forKey: "Hub")
        //archiver.finishEncoding()
        //data.writeToFile(getDataFilePath(), atomically: true)
        
        //TODO: [warning] incomplete implementation; define the required data object to place
        //  in encodeObject()'s first param (dictionary, array, etc)
    }
    
    //TODO: load-data function here:
    func loadAppData() {
        //complete the implementation: 
    }
    
    //check the state of T&C and set key to 'true' if they've been accepted
    func userAcceptedTermsAndConditions(flag: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if flag {
            userDefaults.setBool(true, forKey: "TermsConditionsAccepted")
            userDefaults.synchronize()
        }
    }
    
    //TODO: sort contacts by name function here:
    
    
    
    /*=GET=DOCUMENT=DIRECTORY=AND=DATA=FILE=PATH=*/
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        return paths[0]
    }
    
    func getDataFilePath() -> String {
        return (getDocumentsDirectory()
            as NSString).stringByAppendingPathComponent("Hub.plist")
    }
}
