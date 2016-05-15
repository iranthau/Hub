//
//  TestProfileViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 23/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class TestProfileViewController: UIViewController {
    
    @IBOutlet weak var settingsTestTabBarItem:UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped() {
        performSegueWithIdentifier("TabFromProfileSegue", sender: nil)
    }
    
    @IBAction func settingsItemTapped() {
        performSegueWithIdentifier("TabFromProfileSegue", sender: nil)
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
