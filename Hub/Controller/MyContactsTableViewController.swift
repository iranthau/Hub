//  MyContactsTableViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 7/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class MyContactsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let hubModel = HubModel.sharedInstance
    var myContacts = [User]()
    var filteredContacts = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hubModel.currentUser!.getFriends(self)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active {
            return 1
        }
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredContacts.count
        }
        
        return sections[section].length
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)
        
        let contact: User
        
        if searchController.active && searchController.searchBar.text != "" {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = myContacts[sections[indexPath.section].index + indexPath.row]
        }
        
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
    
    func refreshTableViewInBackground() {
        dispatch_async(dispatch_get_main_queue(), {
            self.addSectionToTableViewController()
            self.tableView.reloadData()
        })
    }
    
    func addSectionToTableViewController() {
        sections = [(index: Int, length :Int, title: String)]()
        var index = 0
        var i = 0
        
        for _ in myContacts {
            
            let commonPrefix = myContacts[i].firstName!.commonPrefixWithString(myContacts[index].firstName!, options: .CaseInsensitiveSearch)
            
            if(commonPrefix.characters.count == 0) {
                let string = myContacts[index].firstName!.uppercaseString;
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: index, length: i - index, title: title)
                sections.append(newSection)
                index = i;
            }
            
            if(i == myContacts.count - 1) {
                let length = i - index + 1
                let string = myContacts[index].firstName!.uppercaseString;
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: index, length: length, title: title)
                sections.append(newSection)
            }
            
            i = i + 1
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredContacts = myContacts.filter { contact in
            let stringGetSearched = contact.firstName! + " " + contact.lastName!
            return stringGetSearched.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        }
        return true
    }

    // Need to handle removing a friend from parse as well.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            myContacts.removeAtIndex(sections[indexPath.section].index + indexPath.row)
            self.refreshTableViewInBackground()
        }
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            if searchController.active {
                return ""
            }
            return sections[section].title
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView)
        -> [String]? {
            if searchController.active {
                return nil
            }
            return sections.map { $0.title }
    }
    
    override func tableView(tableView: UITableView,
        sectionForSectionIndexTitle title: String,
        atIndex index: Int)
        -> Int {
            return index
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make sure the row does not remain selected after the user touched it
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let contact = myContacts[sections[indexPath.section].index + indexPath.row]
        self.performSegueWithIdentifier("contactProfileSegue", sender: contact)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contactProfileSegue" {
            let friendProfile = sender as! User
            if let destinationVC = segue.destinationViewController as? ProfileContactViewController {
                destinationVC.contactProfile = friendProfile
            }
        }
    }
}
