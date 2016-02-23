//
//  MyProfileTestData.swift
//  Hub
//
//  Created by Alexei Gudimenko on 9/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//
//  Test class containing properties to fill fields and image views in MyProfile
//  scene. This should be deleted for production, as its purpose is simply to
//  simulate a model so that the functionality can be created and tested in a live
//  environment. It models information of a single user (in this case: owner of
//  the app, who is assumed to be already logged into the app).

import UIKit

class MyProfileTestData {
    
    var userFirstName = "John"
    var userLastName = "Smith"
    var userImageName = "placeholder-image"
    var userImage = UIImage(named: "placeholder-image")
    var userNickname = "Johnny"
    var userCity = "Melbourne"
    var userAvailability = ""

    
    
    var phoneNumberTestData = [
        "0421433433",
        "0431623946"
    ]
    
    var emailTestData = [
        "whispering.gloom@live.com.au",
        "alexei.gudimenko@gmail.com",
        "spear.of.longinus@gmx.com"
    ]
    
    var addressTestData = [
        "92, Wilson St, Cheltenham",
        "2, Alvina Crt, Frankston",
        "811, Princes Hwy, Springvale",
        "1, Flinders St, Melbourne"
    ]
    
    var socialTestData = [
        "www.facebook.com/j_smith",
        "www.linkedin.com/j_smith"
    ]
}