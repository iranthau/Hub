//
//  AddContactTableTableViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 21/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit
import Parse
import Foundation
import MessageUI

class AddContactTableViewController: UITableViewController, UISearchResultsUpdating, MFMailComposeViewControllerDelegate {
    
    var myContacts = [User]()
    var filteredContacts = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search contacts by their name"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredContacts.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("addContactCell",
            forIndexPath: indexPath)
        
        let contact = filteredContacts[indexPath.row]
        
        if let profileImage = cell.viewWithTag(1) as? UIImageView {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let image = contact.getProfileImage()
                profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
                profileImage.clipsToBounds = true
                
                dispatch_async(dispatch_get_main_queue()) {
                    profileImage.image = image
                }
            }
        }
        
        if let nameLabel = cell.viewWithTag(2) as? UILabel {
            nameLabel.text = "\(contact.firstName) \(contact.lastName)"
        }
        
        if let nickNameLabel = cell.viewWithTag(3) as? UILabel {
            nickNameLabel.text = contact.nickName
        }
        
        if let cityLabel = cell.viewWithTag(4) as? UILabel {
            cityLabel.text = contact.cityName
        }

        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let textToSearch = searchController.searchBar.text!
        
        if !textToSearch.isEmpty {
            filterContentForSearchText(textToSearch)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        let query = PFUser.query()
        
        query!.whereKey("firstName", hasPrefix: searchText)
        query!.whereKey("profileIsVisible", equalTo: true)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                var profiles = [User]()
                if let objects = objects {
                    for userObject in objects as! [PFUser] {
                        profiles.append(self.hubModel.pfUserToUser(userObject))
                    }
                    self.filteredContacts = profiles
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func inviteFriend(sender: UIBarButtonItem) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let mailBody = "Try out new Heyya. It's awesome! Download it here http://www.ioscreator.com/"
        
        mailComposerVC.setSubject("Join Heyya")
        mailComposerVC.setMessageBody(mailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertError = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        
        self.presentViewController(alertError, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make sure the row does not remain selected after the user touched it
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let contact = filteredContacts[indexPath.row]
        self.performSegueWithIdentifier("addContactSegue", sender: contact)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addContactSegue" {
            let profileToAdd = sender as! User
            if let destinationVC = segue.destinationViewController as? AddContactController {
                destinationVC.contactProfile = profileToAdd
            }
        }
    }
}
