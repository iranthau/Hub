//  RequestsTableViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 17/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class RequestsTableViewController: UITableViewController {
    
    var currentUser: User?
    var requests = [User]()
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = hubModel.currentUser
        if let currentUser = currentUser {
            currentUser.getRequests(self)
        }
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
        let request = requests[indexPath.row]
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        let nameLabel = cell.viewWithTag(2) as! UILabel
        let nickNameLabel = cell.viewWithTag(3) as! UILabel
        let cityLabel = cell.viewWithTag(4) as! UILabel
        
        request.getProfileImage(profileImageView)
        ViewFactory.makeImageViewRound(profileImageView)
        nameLabel.text = "\(request.firstName!) \(request.lastName!)"
        ViewFactory.setLabelPlaceholder("nickname", text: request.nickname, label: nickNameLabel)
        ViewFactory.setLabelPlaceholder("city", text: request.city, label: cityLabel)
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let acceptAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Accept" , handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.acceptRequest(tableView, indexPath: indexPath)
        })
        
        acceptAction.backgroundColor = UIColor(hue: 0.3, saturation: 1, brightness: 0.67, alpha: 1.0)

        let declineAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Decline" , handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.declineRequest(tableView, indexPath: indexPath)
        })
        
        return [declineAction, acceptAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let animation = CATransform3DTranslate(CATransform3DIdentity, -100, 0, 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let container = cell!.viewWithTag(5)! as UIView
        let background = cell!.viewWithTag(6)! as UIView
        container.layer.transform = animation
        container.layer.backgroundColor = UIColor.whiteColor().CGColor
        background.layer.backgroundColor = UIColor.redColor().CGColor
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        UIView.animateWithDuration(1.0, animations: {
            () -> Void in
            container.layer.transform = CATransform3DIdentity
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let requestContact = sender as! User
        
        if segue.identifier == "acceptRequestSegue" {
            if let destinationVC = segue.destinationViewController as? ContactRequestTableViewController {
                destinationVC.friend = requestContact
            }
        }
    }
    
    //-------------------Private Methods------------------------
    func acceptRequest(tableView: UITableView, indexPath: NSIndexPath) {
        let requestContact = requests[indexPath.row]
        self.performSegueWithIdentifier("acceptRequestSegue", sender: requestContact)
    }
    
    func declineRequest(tableView: UITableView, indexPath: NSIndexPath) {
        requests.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}
