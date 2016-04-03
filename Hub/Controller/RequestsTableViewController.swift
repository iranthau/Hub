//
//  RequestsTableViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 17/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class RequestsTableViewController: UITableViewController {
    
    var requests = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath)

        let request: User

        request = requests[indexPath.row]
        
        if let profileImage = cell.viewWithTag(1) as? UIImageView {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let image = UIImage(named: "placeholder-image") //request.getProfileImage()
                profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
                profileImage.clipsToBounds = true
                
                dispatch_async(dispatch_get_main_queue()) {
                    profileImage.image = image
                }
            }
        }
        
        if let nameLabel = cell.viewWithTag(2) as? UILabel {
            nameLabel.text = "\(request.firstName) \(request.lastName)"
        }
        
        if let nickNameLabel = cell.viewWithTag(3) as? UILabel {
            nickNameLabel.text = request.nickname
        }
        
        if let cityLabel = cell.viewWithTag(4) as? UILabel {
            cityLabel.text = request.city
        }
        
        return cell
    }
    
    func refreshTableViewInBackground() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let acceptAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Accept" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.acceptRequest(tableView, indexPath: indexPath)
        })
        
        acceptAction.backgroundColor = UIColor(hue: 0.3, saturation: 1, brightness: 0.67, alpha: 1.0)

        let declineAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Decline" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.declineRequest(tableView, indexPath: indexPath)
        })
        
        return [declineAction, acceptAction]
    }
    
    func acceptRequest(tableView: UITableView, indexPath: NSIndexPath) {
        let requestContact = requests[indexPath.row]
        let dataToSend = ["user": requestContact, "vc": self]
        self.performSegueWithIdentifier("acceptRequestSegue", sender: dataToSend)
    }
    
    func declineRequest(tableView: UITableView, indexPath: NSIndexPath) {
        requests.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dataToSend = sender as! [String: AnyObject]
        
        if segue.identifier == "acceptRequestSegue" {
            if let destinationVC = segue.destinationViewController as? ContactRequestTableViewController {
                destinationVC.requestContact = dataToSend["user"] as? User
                destinationVC.viewController = dataToSend["vc"] as? RequestsTableViewController
            }
        }
    }
}
