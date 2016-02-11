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
    @IBOutlet weak var hideProfileCell: UITableViewCell!
    @IBOutlet weak var hideProfileImage: UIImage!
    
    var cell:UITableViewCell?
    
    //Methods begin here:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the separator line between cells
        self.tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        /*check the state of hideProfileSwitch here:*/
        //hideProfileSwitch.on =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //get the table view cell depending on which row the user tapped.
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
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
    
    // customize the settings view cell appearance:
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 600, bottom: 0, right: 0)
    }
    
    // MARK: - decide what happens when a user taps a row in the Settings screen (whether
    //  they will go to another screen, sign out, etc.)
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make sure the row does not remain selected after the user touched it
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("TermsAndConditionsSegue", sender: nil)
        case 1:
            performSegueWithIdentifier("AboutSegue", sender: nil)
            //TODO: - write cases for other rows that require action as functionality is implemented
        default:
            return
        }
    }
    
    //MARK: - prepare for navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TermsAndConditionsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! TermsConditionsViewController
            //disable the 'agree' button if the user has navigated to T&C screen from another part
            // of the app (rather than through first-time launch)
            controller.agreeIsEnabled = false
        }
    }
    
    //UI @IBAction methods live here:
    @IBAction func hideProfileToggle(switchControl: UISwitch) {
        // 1. hide profile
        
        // 2. display a quick status message
    }
    
    //If user taps the 'log out' row, log him out of the system, set userIsLoggedIn to false and 
    //  return them to home screen
    func userDidTapSignoutRow() {
        
        // 0. prompt if user is sure they want to sign out (optional - discuss with Iran)
        
        // 1. save any data that needs to be saved prior to signing out
        
        // 2. set the logged in flag to false, set any other states that need to be set
        
        // 3. return user to log-in screen
        
    }
}
