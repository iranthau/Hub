//
//  ProfileContactViewController.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 12/03/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class ProfileContactViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var SelectedButtonColorView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var contactHoursTextView: UITextView!
    @IBOutlet weak var sharedContactsTableView: UITableView!
    @IBOutlet weak var mySharedContactsTableView: UITableView!
    
    let userData = MyProfileTestData()
    var activeDataSource:[String] = []
    var mySharedContacts:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(userData.userFirstName) \(userData.userLastName)"
        profileImageView.image = userData.userImage
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        nickNameLabel.text = userData.userNickname
        cityLabel.text = userData.userCity
        contactHoursTextView.text = userData.userAvailability
        
        activeDataSource = userData.phoneNumberTestData
        
        mySharedContacts = userData.addressTestData + userData.emailTestData
        
        scrollView.contentSize.height = 826
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
            blue: 27/255.0, alpha: 1)
        
        activeDataSource = userData.phoneNumberTestData
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func emailButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0,
            blue: 51/255.0, alpha: 1)
        
        activeDataSource = userData.emailTestData
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func addressButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 212/255.0, green: 149/255.0,
            blue: 225/255.0, alpha: 1)
        
        activeDataSource = userData.addressTestData
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func socialButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 138/255.0, green: 194/255.0,
            blue: 81/255.0, alpha: 1)
        
        activeDataSource = userData.socialTestData
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func configureSharedContacts(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("configureSharedContactsSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let user = User(fName: userData.userFirstName, lName: userData.userLastName, email: "iranthau@asas.com")
        
        if segue.identifier == "configureSharedContactsSegue" {
            if let destinationVC = segue.destinationViewController as? ContactRequestTableViewController {
                destinationVC.requestContact = user
            }
        }
    }
}

extension ProfileContactViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mySharedContactsTableView {
            return mySharedContacts.count
        }
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String? {
            if tableView == self.mySharedContactsTableView {
                return "\(userData.userNickname) can see"
            }
            
            return ""
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "ContactItemCell"
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                forIndexPath: indexPath)
            
            let label = cell.viewWithTag(1) as! UILabel
            
            if tableView == self.mySharedContactsTableView {
                label.text = mySharedContacts[indexPath.row]
            } else {
                label.text = activeDataSource[indexPath.row]
            }
            
            return cell
    }
}
