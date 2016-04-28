//  HeyyaTabBarController.swift
//  Hub
//  Created by Irantha Rajakaruna on 13/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class HeyyaTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = self.tabBar.items
        ViewFactory.setTabBarItemImageColorToOriginal(items!)
        
        // Set the tab bar item text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
