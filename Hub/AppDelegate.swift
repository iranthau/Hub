//  AppDelegate.swift
//  Hub
//  Created by Irantha Rajakaruna on 3/12/2015.
//  Copyright © 2015 88Software. All rights reserved.

import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Parse.enableLocalDatastore() // Use local datastore
        configureParseAPI(launchOptions)
        configureNotifications(application)
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
        FBSDKAppEvents.activateApp()
        clearBadges()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        confgureCurrentParseInstallation(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == UIApplicationState.Active {
            PFPush.handlePush(userInfo)
        } else {
            showRequestVC()
        }
    }
    
    //----------------------Private functions---------------------------------
    
    private func configureParseAPI(launchOptions: [NSObject: AnyObject]?) {
        User.registerSubclass()
        Contact.registerSubclass()
        SharedPermission.registerSubclass()
        Parse.setApplicationId("inQev5jlG1BWu0LdsRHBK5XbyQrADMJ6BwGXweEF", clientKey: "p2C6htbwjtzV0syI7zXsjiWxbQajREwoJdreYDL0")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    }
    
    private func configureNotifications(application: UIApplication) {
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    private func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UITabBar.appearance().barTintColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        let tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = tintColor
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
    }
    
    private func confgureCurrentParseInstallation(deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        if PFUser.currentUser() != nil {
            installation["user"] = PFUser.currentUser()
        }
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    private func showRequestVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("HeyyaTabBarController") as! UITabBarController
        if PFUser.currentUser() != nil {
            tabBarController.selectedIndex = 2
            self.window!.rootViewController = tabBarController
        }
    }
    
    private func clearBadges() {
        let installation = PFInstallation.currentInstallation()
        installation.badge = 0
        installation.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            }
        }
    }
}
