//  SettingsViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 11/01/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
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
        if let currentUser = currentUser {
            hideProfileSwitch.on = !currentUser.profileIsVisible
        }
        tableView.separatorColor = ViewFactory.hidden()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
                removeAccountFromParse()
            case 7:
                signOut()
            default:
                break
        }
    }
    
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
        if let currentUser = currentUser {
            currentUser.profileIsVisible = !switchControl.on
        }
    }
    
    func performTermsSegue() {
        performSegueWithIdentifier("TermsAndConditionsSegue", sender: nil)
    }
    
    func performAboutSegue() {
        performSegueWithIdentifier("AboutSegue", sender: nil)
    }
    
    //TODO: Help screens need to implememted
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
    
    func removeAccountFromParse() {
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
    
    func signOut() {
        let message = "Sign out?"
        let alertError = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action: UIAlertAction!) in
            if let currentUser = self.currentUser {
                currentUser.logOut {
                    (error) in
                    if let error = error {
                        self.showAlert(error)
                    } else {
                        self.performSegueWithIdentifier("signOutSegue", sender: nil)
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertError.addAction(okAction)
        alertError.addAction(cancelAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    //----------------------Private methods-------------------------
    
    func showAlert(message: String) {
        let alertError = UIAlertController(title: "Settings", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    private func handleDeletion() {
        if let currentUser = currentUser {
            currentUser.deleteAccount {
                (success, error) in
                if let error = error {
                    print(error)
                } else if success {
                    self.performSegueWithIdentifier("signOutSegue", sender: nil)
                }
            }
        }
    }
}
