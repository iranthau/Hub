//
//  SettingsViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 11/01/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    //Variables (properties, outlets, etc) begin here:
    @IBOutlet weak var hideProfileSwitch: UISwitch!
    
    //Methods begin here:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*check the state of hideProfileSwitch here:*/
        //hideProfileSwitch.on =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //WARNING: check this during testing, as this method may require additional overriding
    // of the tableView() methods, as it's a prototype-intended method type. Static cells
    // are designed in the storyboard, so the size may need to be set there in some way!!! - A.G. 11/01/16
    //give the bottom cell a unique size to display multiple lines of text
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.section == 0 && indexPath.row == 9 {
                return 87 //height of bottom cell with team statement
            } else {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            }
    }
    
    //table view delegate method:
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath
        indexPath: NSIndexPath) -> NSIndexPath? {
            
            //return the index path row depends on what user taps, and perform
            switch indexPath.row {
            case 1:
                return indexPath
            case 2:
                return indexPath
            case 3:
                return indexPath
            case 4:
                return indexPath
            case 5:
                return indexPath
            case 6:
                return indexPath
            case 7:
                return indexPath
            case 8:
                return indexPath
            case 9:
                return indexPath
            default:
                return nil
            }
    }
    
    //get the table view cell depending on which row the user tapped.
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //if user tapped an accessory button, perform segue to the correct screen
    }
    
    //UI @IBAction methods live here:
    @IBAction func hideProfileToggle(switchControl: UISwitch) {
        
    }
}