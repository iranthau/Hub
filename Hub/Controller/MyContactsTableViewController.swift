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
    let collation = UILocalizedIndexedCollation.currentCollation()
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hubModel.getAllContacts(self)
        
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
    
    func refreshTableViewInBackground() {
        dispatch_async(dispatch_get_main_queue(), {
            self.addSectionToTableViewController()
            self.tableView.reloadData()
        })
    }
    
    func addSectionToTableViewController() {
        var index = 0
        var i = 0
        
        for _ in myContacts {
            
            let commonPrefix = myContacts[i].firstName.commonPrefixWithString(myContacts[index].firstName, options: .CaseInsensitiveSearch)
            
            if (commonPrefix.characters.count == 0 || i == myContacts.count - 1) {
                let string = myContacts[index].firstName.uppercaseString;
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: index, length: i - index, title: title)
                sections.append(newSection)
                index = i;
            }
            
            i = i + 1
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredContacts = myContacts.filter { contact in
            let stringGetSearched = contact.firstName + " " + contact.lastName
            return stringGetSearched.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if searchController.active {
            return false
        }
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            myContacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
