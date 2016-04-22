//  EditMyProfileViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 11/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit
import Parse

class EditMyProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var availabilityTextField: UITextView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var contactFieldTableView: UITableView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageChangeButton: UIButton!
    @IBOutlet weak var selectedContactColor: UIView!
    @IBOutlet weak var finishEditingButton: UIBarButtonItem!
    
    weak var delegate: EditMyProfileDelegate?
    var imagePicker = UIImagePickerController()
    var activeTextField: UITextField?
    let viewInitialPointOfOrigin: CGFloat = 64.0
    
    var currentUser: User?
    let hubModel = HubModel.sharedInstance
    var activeDataSource = [Contact]()
    var keyboardForContactType = ContactType.Phone.rawValue
    
    var allContacts = [Contact]()
    var phoneContacts = [Contact]()
    var emailContacts = [Contact]()
    var addressContacts = [Contact]()
    var socialContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = hubModel.currentUser
        ViewFactory.makeImageViewRound(profileImageView)
        
        //Fill up contacts arrays to have all type of contacts initially
        phoneContacts = HubUtility.initialisePhoneContacts()
        emailContacts = HubUtility.initialiseEmailContacts()
        addressContacts = HubUtility.initialiseAddressContacts()
        socialContacts = HubUtility.initialiseSocialContacts()
        
        //When the view load phone contacts are displayed first
        activeDataSource = phoneContacts
        selectedContactColor.backgroundColor = ViewFactory.backGroundColor(ContactType.Phone)

        //Sets the initial values of the text fields
        if let currentUser = currentUser {
            firstNameTextField.text = currentUser.firstName
            lastNameTextField.text = currentUser.lastName
            nicknameTextField.text = currentUser.nickname
            ViewFactory.setTextViewPlaceholder("When can others contact you", text: currentUser.availableTime, textView: availabilityTextField)
            currentUser.getProfileImage(profileImageView)
            allContacts = currentUser.contacts
        }
        
        //Assigns user contacts to their corresponding textfields
        matchInitialContactsValues()
        
        //Move the view up when a textfield is coverd by the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMyProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMyProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
        
        finishEditingButton.enabled = false
    }

    //Cancel editing will dismiss the edit view controller
    @IBAction func cancel() {
        delegate?.editMyProfileViewControllerDidCancel(self)
    }
    
    //Once editing is finished
    // 1. append all contacts in to an array
    // 2. Filter contacts out if their value is empty && if they did not exist previosly
    // 3. Update the user value to new values
    // 4. Save the user to parse
    @IBAction func done() {
        var editedContacts = [Contact]()
        editedContacts += phoneContacts
        editedContacts += emailContacts
        editedContacts += addressContacts
        editedContacts += socialContacts
        let contactsToSave = filterContacts(editedContacts)

        if let currentUser = currentUser {
            currentUser.firstName = firstNameTextField.text!
            currentUser.lastName = lastNameTextField.text!
            currentUser.nickname = nicknameTextField.text!
            currentUser.availableTime = availabilityTextField.text!
            currentUser.setProfileImage(profileImageView.image!)
            currentUser.setContacts(contactsToSave)
            dismissViewController(currentUser)
        }
    }
    
    @IBAction func phoneButtonPressed() {
        selectedContactColor.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0, blue: 27/255.0, alpha: 1)
        activeDataSource = phoneContacts
        keyboardForContactType = 1
        contactFieldTableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        selectedContactColor.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0, blue: 51/255.0, alpha: 1)
        activeDataSource = emailContacts
        keyboardForContactType = 2
        contactFieldTableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        selectedContactColor.backgroundColor = UIColor(red: 212/255.0, green: 149/255.0, blue: 225/255.0, alpha: 1)
        activeDataSource = addressContacts
        contactFieldTableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        selectedContactColor.backgroundColor = UIColor(red: 138/255.0, green: 194/255.0, blue: 81/255.0, alpha: 1)
        activeDataSource = socialContacts
        contactFieldTableView.reloadData()
    }

    @IBAction func changeProfileImage() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.hubModel.openCamera(self.imagePicker, view: self)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.hubModel.openGallary(self.imagePicker, view: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        imagePicker.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Methods that required for the table view to work properly
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditContactCell") as! EditContactItemCell
        let textField = cell.contactInputTextField
        let contact = activeDataSource[indexPath.row]
        textField.delegate = self
        textField.text = contact.value
        textField.placeholder = contact.subType
        let imageName = contact.getImageName()
        cell.contactImage.image = UIImage(named: imageName)
        cell.configureKeyboardForContactType(keyboardForContactType)
        cell.contact = contact
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    //track the active text field
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let cell = textField.superview!.superview as! EditContactItemCell
        cell.contact!.value = textField.text!
        activeTextField = nil
    }
    
    func keyboardWillHide(sender: NSNotification) {
        finishEditingButton.enabled = true
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y = viewInitialPointOfOrigin
    }
    
    func keyboardWillShow(sender: NSNotification) {
        finishEditingButton.enabled = false
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        if activeTextField != availabilityTextField && activeTextField != firstNameTextField &&
            activeTextField != lastNameTextField {
            if keyboardSize == offset {
                if self.view.frame.origin.y == viewInitialPointOfOrigin {
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        self.view.frame.origin.y -= keyboardSize.height
                    })
                }
            } else {
                UIView.animateWithDuration(0.1, animations: {
                    () -> Void in
                    self.view.frame.origin.y += keyboardSize.height - offset.height
                })
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    //hide keyboard on background tap
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    //hide keyboard on pressing return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
        profileImageView.clipsToBounds = true
        profileImageView.image = image
    }
    
    // Extra methods that needs for this controller to work properly
    func matchInitialContactsValues() {
        for contact in allContacts {
            switch contact.type! {
            case ContactType.Phone.label:
                putContactsInAppropriateTextfield(contact, contacts: phoneContacts)
            case ContactType.Email.label:
                putContactsInAppropriateTextfield(contact, contacts: emailContacts)
            case ContactType.Address.label:
                putContactsInAppropriateTextfield(contact, contacts: addressContacts)
            case ContactType.Social.label:
                putContactsInAppropriateTextfield(contact, contacts: socialContacts)
            default:
                break
            }
        }
    }
    
    func putContactsInAppropriateTextfield(contactToMatch: Contact, contacts: [Contact]) {
        for contact in contacts {
            if contact.subType == contactToMatch.subType {
                contact.objectId = contactToMatch.objectId
                contact.value = contactToMatch.value
            }
        }
    }
    
    func filterContacts(editedContacts: [Contact]) -> [Contact] {
        var contactsToSave = [Contact]()
        for contact in editedContacts {
            if contact.objectId != nil || contact.value != nil {
                contactsToSave.append(contact)
            }
        }
        return contactsToSave
    }
    
    func dismissViewController(user: User) {
        delegate?.editMyProfileViewController(self, didFinishEditingProfile: user)
    }
}

