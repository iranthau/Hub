//
//  HeyyaTabBarController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 13/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class HeyyaTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tab bar item image color to image's original color
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
        // Set the tab bar item text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
