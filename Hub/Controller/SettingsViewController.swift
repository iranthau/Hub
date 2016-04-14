//  SettingsViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 11/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse
import MessageUI

class SettingsViewController: UITableViewController {

    @IBOutlet weak var hideProfileSwitch: UISwitch!
    var mailComposer: MFMailComposer?
    var currentUser: User?
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        currentUser = hubModel.currentUser
        mailComposer = MFMailComposer(tableVC: self)
        hideProfileSwitch.on = currentUser!.profileIsVisible!
        
        //hide the separator line between cells
        self.tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //get the table view cell depending on which row the user tapped.
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make sure the row does not remain selected after the user touched it
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performTermsSegue()
        case 1:
            performAboutSegue()
        case 2:
            help()
        case 3:
            tellAFriend()
        case 4:
            deleteAccount()
        case 7:
            signOut()
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
    
    @IBAction func hideProfileToggle(switchControl: UISwitch) {
        currentUser!.hideProfile(switchControl.on)
    }
    
    func performTermsSegue() {
        performSegueWithIdentifier("TermsAndConditionsSegue", sender: nil)
    }
    
    func performAboutSegue() {
        performSegueWithIdentifier("AboutSegue", sender: nil)
    }
    
    func deleteAccount() {
        let message = "This action can not be undone. Would you like to continue?"
        let alertError = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.handleDeletion()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertError.addAction(okAction)
        alertError.addAction(cancelAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    func handleDeletion() {
        let user = currentUser!.matchingParseObject
        let contacts = user.objectForKey("contacts") as? [PFObject]
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        deleteUserFromSharedPermission(user)
        deleteUserFriendFromSharedPermission(user)
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.deleteContacts(contacts)
            dispatch_async(dispatch_get_main_queue()) {
                self.deleteUser(user)
            }
        }
    }
    
    func deleteUser(user: PFUser) {
        user.deleteInBackgroundWithBlock {
            (success: Bool, error: NSError?) in
            if success {
                PFUser.logOut()
                self.performSegueWithIdentifier("signOutSegue", sender: nil)
            }
        }
    }
    
    func deleteContacts(contacts: [PFObject]?) {
        if let contacts = contacts {
            for contact in contacts {
                do {
                    try contact.delete()
                } catch {
                    print("\(contact.objectId) could not be deleted")
                }
            }
        }
    }
    
    func deleteUserFriendFromSharedPermission(user: PFUser) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("userFriend", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) in
            if let objects = objects {
                for object in objects {
                    object.deleteInBackground()
                }
            }
        }
    }
    
    func deleteUserFromSharedPermission(user: PFUser) {
        let query = PFQuery(className: "SharedPermission")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) in
            if let objects = objects {
                for object in objects {
                    object.deleteInBackground()
                }
            }
        }
    }
    
    func signOut() {
        let message = "Sign out?"
        let alertError = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            PFUser.logOutInBackgroundWithBlock({ (error: NSError?) -> Void in
                if(error == nil) {
                    self.performSegueWithIdentifier("signOutSegue", sender: nil)
                }
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertError.addAction(okAction)
        alertError.addAction(cancelAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    func help() {
        let alertError = UIAlertController(title: "Help", message: "Coming soon...", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    func tellAFriend() {
        let mailComposeViewController = mailComposer!.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            mailComposer!.showSendMailErrorAlert()
        }
    }
}
