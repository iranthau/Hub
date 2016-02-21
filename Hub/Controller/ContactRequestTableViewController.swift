//
//  ContactRequestTableViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 16/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class ContactRequestTableViewController: UITableViewController, ContactShareCellDelegate {
    
    var requestContact: User?
    var viewController: RequestsTableViewController?
    var contacts = [(imageName: String, contact: String, shared: Bool)]()
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = requestContact!.firstName
        
        self.tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        
        contacts = hubModel.contactRequests
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactTypeCell", forIndexPath: indexPath) as! ContactShareCell
        
        if let contactLabel = cell.viewWithTag(1) as? UILabel {
            contactLabel.text = contacts[indexPath.row].contact
        }
        
        if let sharedSwitch = cell.viewWithTag(3) as? UISwitch {
            sharedSwitch.setOn(contacts[indexPath.row].shared, animated: true)
        }
        
        if let contactImage = cell.viewWithTag(2) as? UIImageView {
            let image = UIImage(named: contacts[indexPath.row].imageName)
            contactImage.image = image
        }
        
        cell.cellDelegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            return "Select what \(requestContact!.firstName) can see"
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func acceptRequest(sender: UIBarButtonItem) {
        print(contacts)
        viewController!.requests.removeObject(requestContact!)
        viewController!.tableView.reloadData()
        self.back(sender)
    }
    
    func switchStateChanged(sender: ContactShareCell, isOn: Bool) {
        let indexPath = self.tableView.indexPathForCell(sender)
        contacts[indexPath!.row].shared = isOn
    }
}

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
