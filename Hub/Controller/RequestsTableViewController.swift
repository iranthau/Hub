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
    let hubModel = HubModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        hubModel.currentUser!.getRequests(self)
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
        let imageFile = request.profileImage
        
        if let profileImage = cell.viewWithTag(1) as? UIImageView {
            imageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        profileImage.image = UIImage(data:imageData)
                    }
                }
            }
            profileImage.layer.cornerRadius = 0.5 * profileImage.bounds.size.width
            profileImage.clipsToBounds = true
        }
        
        if let nameLabel = cell.viewWithTag(2) as? UILabel {
            nameLabel.text = "\(request.firstName!) \(request.lastName!)"
        }
        
        if let nickNameLabel = cell.viewWithTag(3) as? UILabel {
            if request.nickname == nil {
                nickNameLabel.text = "nickname"
                nickNameLabel.textColor = UIColor.lightGrayColor()
            } else {
                nickNameLabel.text = request.nickname!
            }
        }
        
        if let cityLabel = cell.viewWithTag(4) as? UILabel {
            if request.city == nil {
                cityLabel.text = "city"
                cityLabel.textColor = UIColor.lightGrayColor()
            } else {
                cityLabel.text = request.city!
            }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make sure the row does not remain selected after the user touched it
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let animation = CATransform3DTranslate(CATransform3DIdentity, -100, 0, 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let background = cell!.viewWithTag(6)! as UIView
        let container = cell!.viewWithTag(5)! as UIView
        container.layer.transform = animation
        container.layer.backgroundColor = UIColor.whiteColor().CGColor
        background.layer.backgroundColor = UIColor.redColor().CGColor
        
        UIView.animateWithDuration(1.0, animations: {
            () -> Void in
            container.layer.transform = CATransform3DIdentity
        })
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
