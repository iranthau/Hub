//  AddContactTableTableViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 21/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
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
        configureSearchController()
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        mailComposer = MFMailComposer(tableVC: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("addContactCell", forIndexPath: indexPath)
        let contact = filteredContacts[indexPath.row]
        let profileImage = cell.viewWithTag(1) as! UIImageView
        let nameLabel = cell.viewWithTag(2) as! UILabel
        let nickNameLabel = cell.viewWithTag(3) as! UILabel
        let cityLabel = cell.viewWithTag(4) as! UILabel
        
        contact.getProfileImage {
            (image) in
            profileImage.image = image
        }
        ViewFactory.makeImageViewRound(profileImage)
        nameLabel.text = "\(contact.firstName) \(contact.lastName)"
        ViewFactory.setCellLabelPlaceholder("nickname", text: contact.nickname, label: nickNameLabel)
        ViewFactory.setCellLabelPlaceholder("city", text: contact.city, label: cityLabel)
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let textToSearch = searchController.searchBar.text!
        if !textToSearch.isEmpty {
            filterContentForSearchText(textToSearch)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        if let user = currentUser {
            user.searchForFriends(searchText, completion: {
                (users: [User]?, error: String?) in
                if let error = error {
                    print(error)
                } else if let users = users {
                    self.filteredContacts = users
                    self.tableView.reloadData()
                }
            })
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let contact = filteredContacts[indexPath.row]
        self.performSegueWithIdentifier("addContactSegue", sender: contact)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addContactSegue" {
            let profileToAdd = sender as! User
            if let destinationVC = segue.destinationViewController as? AddContactViewController {
                destinationVC.contactProfile = profileToAdd
            }
        }
    }
    
    //-----------------------Private methods----------------------------
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search contacts by their name"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
}
