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
    func editMyProfileViewController(controller: EditMyProfileViewController,
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
    
    weak var delegate: EditMyProfileViewControllerDelegate?
    //color reference: UIColor(red: 23/255.0, green: 129/255.0,
    // blue: 204/255.0, alpha: 1.0)
    
    // this variable simulates the user data, in this case to give EditMyProfileView
    //  something to work with for functionality testing.
    //  #warning: replace with correct content from the model!!!! - A. G.
    var userData: MyProfileTestData?
    var activeDataSource = [String]()
    var keyboardForContactType: Int = 0
    var doneIsEnabled = false
    
    var contactFieldCell: EditContactItemCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the separator lines in the table view
        contactFieldTableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        if let user = userData {
            title = "Edit " + user.userFirstName + "'s Profile"
            // perform any other additional setup of the view
            doneNavBarButton.enabled = true
            firstNameTextField.text = user.userFirstName
            lastNameTextField.text = user.userLastName
            nicknameTextField.text = user.userNickname
            profileImageView.image = UIImage(named: user.userImageName)
            activeDataSource = user.phoneNumberTestData
            keyboardForContactType = 1
        }
        
        initialiseTextFields()
        
        //dismiss the keyboard triggered by text fields in table view cells by tapping anywhere on
        // the screen:
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        gestureRecognizer.cancelsTouchesInView = false
        contactFieldTableView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationController?.navigationBar.translucent = false
    }
    
    //Assign a delegate to the main text fields so that they can respond to events in the
    // UI, such as user tapping a return button
    func initialiseTextFields() {
        availabilityTextField.delegate = self
        availabilityTextField.keyboardType = .Default
        firstNameTextField.delegate = self
        firstNameTextField.keyboardType = .Default
        lastNameTextField.delegate = self
        lastNameTextField.keyboardType = .Default
        nicknameTextField.delegate = self
        lastNameTextField.keyboardType = .Default
    }
    
    //If the user presses the 'return' key, hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //cancel editing: dismiss view controller
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //done editing: set new values, dismiss view controller
    @IBAction func done() {
        
        if let userData = userData {
            userData.userFirstName = firstNameTextField.text!
            userData.userLastName = lastNameTextField.text!
            userData.userNickname = nicknameTextField.text!
            delegate?.editMyProfileViewController(self, didFinishEditingProfile: userData)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func phoneButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.phoneNumberTestData
            keyboardForContactType = 1
        }
        
        contactFieldTableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.emailTestData
            keyboardForContactType = 2
        }
        
        contactFieldTableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.addressTestData
            keyboardForContactType = 3
        }
        
        contactFieldTableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.socialTestData
            keyboardForContactType = 4
        }
        
        contactFieldTableView.reloadData()
    }

    
    //function to dismiss keyboard (@see Selector() in viewDidLoad()
    func hideKeyboard(gestureRecogniser: UIGestureRecognizer) {
        let point = gestureRecogniser.locationInView(contactFieldTableView)
        let indexPath = contactFieldTableView.indexPathForRowAtPoint(point)
        
        //if user taps description field, ignore the 'hide keyboard' message
        //otherwise, hide keyboard if user taps somewhere on screen
        
        if let indexPath = indexPath where indexPath.section == 0 && indexPath.row != 0 {
            if let cell = contactFieldCell {
                cell.contactInputTextField.resignFirstResponder()
            }
        }
        
    }
    
    //enable editing of text fields; enable nav bar Done button when there's some text typed
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string:String) -> Bool {
            
            //read in the value of the original text of the checklist item:
            let oldText:NSString = textField.text!
            //replace its value with value of replacementString
            let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
            
            doneNavBarButton.enabled = (newText.length > 0)

            return true
    }
}

extension EditMyProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: implement the cell configuration and allow user to edit content in cells
        let cell = tableView.dequeueReusableCellWithIdentifier("EditContactCell") as! EditContactItemCell
        
        let textField = cell.contactInputTextField
        textField.text = activeDataSource[indexPath.row]
        
        cell.configureKeyboardForContactType(keyboardForContactType)
        
        return cell
    }
}

extension EditMyProfileViewController: UITableViewDelegate {
    //enable row deletion etc
}

extension EditMyProfileViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

