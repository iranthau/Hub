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

class AddContactTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredContacts = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    let hubModel = HubModel.sharedInstance
    var currentUser: User?
    var mailComposer: MFMailComposer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = hubModel.currentUser
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search contacts by their name"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
        mailComposer = MFMailComposer(tableVC: self)
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
            
            let imageFile = contact.profileImage
            profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
            profileImage.clipsToBounds = true
            imageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        profileImage.image = UIImage(data:imageData)
                    }
                }
            }
        }
        
        if let nameLabel = cell.viewWithTag(2) as? UILabel {
            nameLabel.text = "\(contact.firstName!) \(contact.lastName!)"
        }
        
        if let nickNameLabel = cell.viewWithTag(3) as? UILabel {
            if contact.nickname == nil {
                nickNameLabel.text = "nickname"
                nickNameLabel.textColor = UIColor.lightGrayColor()
            } else {
                nickNameLabel.text = contact.nickname!
            }
        }
        
        if let cityLabel = cell.viewWithTag(4) as? UILabel {
            if contact.city == nil {
                cityLabel.text = "city"
                cityLabel.textColor = UIColor.lightGrayColor()
            } else {
                cityLabel.text = contact.city!
            }
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
        query!.whereKey("objectId", notEqualTo: currentUser!.objectId!)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                var profiles = [User]()
                if let objects = objects {
                    for userObject in objects as! [PFUser] {
                        let user = User(parseUser: userObject)
                        user.buildUser()
                        profiles.append(user)
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
        let mailComposeViewController = mailComposer!.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            mailComposer!.showSendMailErrorAlert()
        }
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
            if let destinationVC = segue.destinationViewController as? AddContactViewController {
                destinationVC.contactProfile = profileToAdd
            }
        }
    }
}
