//
//  AppDelegate.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 3/12/2015.
//  Copyright © 2015 88Software. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Use local datastore
//        Parse.enableLocalDatastore()
        
        // Initialise parse
        Parse.setApplicationId("inQev5jlG1BWu0LdsRHBK5XbyQrADMJ6BwGXweEF", clientKey: "p2C6htbwjtzV0syI7zXsjiWxbQajREwoJdreYDL0")
        
        // Set colors and appearance of UI elements:
        customizeAppearance()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // customize tab bar controller appearance and any other app elements that require programmatic view 
    //  change
    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 23/255.0, green: 129/255.0,
            blue: 204/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UITabBar.appearance().barTintColor = UIColor(red: 23/255.0, green: 129/255.0,
            blue: 204/255.0, alpha: 1.0)
        let tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0,
            alpha: 1.0)
        UITabBar.appearance().tintColor = tintColor
    }

}

