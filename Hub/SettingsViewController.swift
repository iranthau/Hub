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
        default:
            return
        }
    }
    
    //MARK: - prepare for navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TermsAndConditionsSegue" {
            let controller = segue.destinationViewController as! TermsConditionsViewController
            //disable the 'agree' button if the user has navigated to T&C screen from another part
            // of the app (rather than through first-time launch)
            controller.agreeIsEnabled = false
        }
    }
    
    //UI @IBAction methods live here:
    @IBAction func hideProfileToggle(switchControl: UISwitch) {
        
    }
    
    //If user taps the 'log out' row, log him out of the system and set a flag
    func userDidLogOut() {
        
    }
}
