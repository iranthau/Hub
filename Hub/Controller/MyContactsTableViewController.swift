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
    
//    var sections: [Section] {
//        if self._sections != nil {
//            return self._sections!
//        }
//        
//        let contacts: [User] = myContacts.map { contact in
//            contact.section = self.collation.sectionForObject(contact, collationStringSelector: "firstName")
//            return contact
//        }
//        
//        var sections = [Section]()
//        
//        for _ in 0..<self.collation.sectionIndexTitles.count {
//            sections.append(Section())
//        }
//        
//        for contact in contacts {
//            sections[contact.section!].addUser(contact)
//        }
//        
//        for section in sections {
//            section.users = self.collation.sortedArrayFromArray(section.users, collationStringSelector: "firstName") as! [User]
//        }
//        
//        self._sections = sections
//        
//        return self._sections!
//    }
    
//    var _sections: [Section]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //self.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredContacts.count
        }
        
        return myContacts.count //self.sections[section].users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)
        
        let contact: User
        
        if searchController.active && searchController.searchBar.text != "" {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = myContacts[indexPath.row] //elf.sections[indexPath.section].users[indexPath.row]
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
            self.tableView.reloadData()
        })
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
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            myContacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
//    override func tableView(tableView: UITableView,
//        titleForHeaderInSection section: Int)
//        -> String {
//            // do not display empty `Section`s
//            if !self.sections[section].users.isEmpty {
//                return self.collation.sectionTitles[section] as String
//            }
//            return ""
//    }
//    
//    override func sectionIndexTitlesForTableView(tableView: UITableView)
//        -> [String]? {
//            return self.collation.sectionIndexTitles
//    }
//    
//    override func tableView(tableView: UITableView,
//        sectionForSectionIndexTitle title: String,
//        atIndex index: Int)
//        -> Int {
//            return self.collation.sectionForSectionIndexTitleAtIndex(index)
//    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
