//  ProfileContactViewController.swift
//  Hub
//  Created by Irantha Rajakaruna on 12/03/2016.
//  Copyright © 2016 88Software. All rights reserved.

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
    
    var contactProfile: User?
    var currentUser: User?
    var mySharedContacts = [Contact]()
    var activeDataSource = [Contact]()
    var sharedPhoneContacts = [Contact]()
    var sharedEmailContacts = [Contact]()
    var sharedAddressContacts = [Contact]()
    var sharedSocialContacts = [Contact]()
    let hubModel = HubModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = hubModel.currentUser
        
        ViewFactory.hideTableViewSeparator(sharedContactsTableView)
        ViewFactory.hideTableViewSeparator(mySharedContactsTableView)
        ViewFactory.makeImageViewRound(profileImageView)
        
        if let contactProfile = contactProfile {
            title = "\(contactProfile.firstName!) \(contactProfile.lastName!)"
            contactProfile.getProfileImage(profileImageView)
            ViewFactory.setLabelPlaceholder("nickname", text: contactProfile.nickname, label: nickNameLabel)
            ViewFactory.setLabelPlaceholder("city", text: contactProfile.city, label: cityLabel)
            ViewFactory.setTextViewPlaceholder("No prefered time provided", text: contactProfile.availableTime, textView: contactHoursTextView)
        }
        
        if let currentUser = currentUser {
            currentUser.getAllSharedContacts(contactProfile!, profileContactVC: self)
            currentUser.getContactsIShared(contactProfile!, profileContactVC: self)
        }
        
        activeDataSource = sharedPhoneContacts
        scrollView.contentSize.height = 826
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func phoneButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
            blue: 27/255.0, alpha: 1)
        
        activeDataSource = sharedPhoneContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func emailButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0,
            blue: 51/255.0, alpha: 1)
        
        activeDataSource = sharedEmailContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func addressButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 212/255.0, green: 149/255.0,
            blue: 225/255.0, alpha: 1)
        
        activeDataSource = sharedAddressContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func socialButtonClicked(sender: UIButton) {
        SelectedButtonColorView.backgroundColor = UIColor(red: 138/255.0, green: 194/255.0,
            blue: 81/255.0, alpha: 1)
        
        activeDataSource = sharedSocialContacts
        sharedContactsTableView.reloadData()
    }
    
    @IBAction func configureSharedContacts(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("configureSharedContactsSegue", sender: nil)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func refreshTableView() {
        SelectedButtonColorView.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
                                                          blue: 27/255.0, alpha: 1)
        activeDataSource = sharedPhoneContacts
        sharedContactsTableView.reloadData()
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let user = User(fName: userData.userFirstName, lName: userData.userLastName, email: "iranthau@asas.com")
//        
//        if segue.identifier == "configureSharedContactsSegue" {
//            if let destinationVC = segue.destinationViewController as? ContactRequestTableViewController {
//                destinationVC.requestContact = user
//            }
//        }
//    }
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
                return "\(contactProfile!.firstName!) can see"
            }
            
            return ""
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ContactItemCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath)
        let icon = cell.viewWithTag(2) as! UIImageView
        let label = cell.viewWithTag(1) as! UILabel
        
        if tableView == self.mySharedContactsTableView {
            label.text = mySharedContacts[indexPath.row].value
            icon.image = UIImage(named: mySharedContacts[indexPath.row].getImageName())
        } else {
            label.text = activeDataSource[indexPath.row].value
            icon.image = UIImage(named: activeDataSource[indexPath.row].getImageName())
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // make sure the row does not remain selected after the user touched it
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
