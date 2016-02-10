//
//  EditMyProfileViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 11/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

protocol EditMyProfileViewControllerDelegate: class {
    func editMyProfileViewControllerDidCancel(controller: EditMyProfileViewController)
    func editMyProfileViewControllerDidFinishEditingProfile(controller: EditMyProfileViewController,
        didFinishEditingProfile userProfile: MyProfileTestData) //#warning: replace with model obj
}

class EditMyProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var availabilityTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var doneNavBarButton: UIBarButtonItem!
    @IBOutlet weak var backgroundViewForProfileImage: UIView!
    @IBOutlet weak var contactFieldTableView: UITableView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    
    //color reference: UIColor(red: 23/255.0, green: 129/255.0,
    // blue: 204/255.0, alpha: 1.0)
    
    // this variable simulates the user data, in this case to give EditMyProfileView
    //  something to work with for functionality testing.
    //  #warning: replace with correct content from the model!!!! - A. G.
    var testDataToEdit: MyProfileTestData?
    var doneIsEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the separator lines in the table view
        contactFieldTableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        if let user = testDataToEdit {
            title = "Edit " + user.userFirstName + "'s Profile"
            // perform any other additional setup of the view
            doneNavBarButton.enabled = doneIsEnabled
        }
    }
    
    //cancel editing: dismiss view controller
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //done editing: set new values, dismiss view controller
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func phoneButtonPressed() {
        
    }
    @IBAction func emailButtonPressed() {
        
    }
    @IBAction func addressButtonPressed() {
        
    }
    @IBAction func socialButtonPressed() {
        
    }
}

extension EditMyProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: implement correct number of rows to display
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: implement the cell configuration and allow user to edit content in cells
        return UITableViewCell()
    }
}

extension EditMyProfileViewController: UITableViewDelegate {
    //enable row deletion etc
}
