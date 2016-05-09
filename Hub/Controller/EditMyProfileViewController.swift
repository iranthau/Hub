//  EditMyProfileViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 11/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class EditMyProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var availabilityTextView: UITextView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
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
    var activeTextView: UITextView?
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
            cityTextField.text = currentUser.city
            ViewFactory.setTextViewPlaceholder("When can others contact you?", text: currentUser.availableTime, textView: availabilityTextView)
            currentUser.getProfileImage(profileImageView)
            allContacts = currentUser.contacts
        }
        
        registerDelegateForInputFields()
        matchInitialContactsValues()
        
        //Move the view up when a textfield is coverd by the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMyProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMyProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
        
        finishEditingButton.enabled = false
        activeTextView = availabilityTextView
    }

    //Cancel editing will dismiss the edit view controller
    @IBAction func cancel() {
        delegate?.editMyProfileViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        let contactsArray = [phoneContacts, emailContacts, addressContacts, socialContacts]
        let editedContacts = HubUtility.appendContactsArrays(contactsArray)
        let contactsToSave = HubUtility.filterContacts(editedContacts)

        if let currentUser = currentUser {
            currentUser.firstName = firstNameTextField.text!
            currentUser.lastName = lastNameTextField.text!
            currentUser.nickname = nicknameTextField.text!
            currentUser.city = cityTextField.text!
            currentUser.availableTime = availabilityTextView.text!
            currentUser.setProfileImage(profileImageView.image!)
            currentUser.setContacts(contactsToSave)
            dismissViewController(currentUser)
        }
    }
    
    @IBAction func phoneButtonPressed() {
        selectedContactColor.backgroundColor = ViewFactory.backGroundColor(ContactType.Phone)
        activeDataSource = phoneContacts
        keyboardForContactType = 1
        contactFieldTableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        selectedContactColor.backgroundColor = ViewFactory.backGroundColor(ContactType.Email)
        activeDataSource = emailContacts
        keyboardForContactType = 2
        contactFieldTableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        selectedContactColor.backgroundColor = ViewFactory.backGroundColor(ContactType.Address)
        activeDataSource = addressContacts
        keyboardForContactType = 3
        contactFieldTableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        selectedContactColor.backgroundColor = ViewFactory.backGroundColor(ContactType.Social)
        activeDataSource = socialContacts
        keyboardForContactType = 3
        contactFieldTableView.reloadData()
    }

    @IBAction func changeProfileImage() {
        let alert = hubModel.buildImagePickAlertController(imagePicker, view: self)
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
    
    //Handle text view changes
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        activeTextView = textView
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        activeTextView = textView
        if textView.text == "When can others contact you?" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "When can others contact you?"
        }
        activeTextView = nil
    }
    
    //Handle textfields changes
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    //Update contact value when the user click outside of the active textfield
    func textFieldDidEndEditing(textField: UITextField) {
        if textField != firstNameTextField && textField != lastNameTextField && textField != nicknameTextField && textField != cityTextField {
            let cell = textField.superview!.superview as! EditContactItemCell
            cell.contact!.value = textField.text!
        }
        activeTextView = nil
    }
    
    func keyboardWillHide(sender: NSNotification) {
        finishEditingButton.enabled = true
        self.view.frame.origin.y = viewInitialPointOfOrigin
    }
    
    func keyboardWillShow(sender: NSNotification) {
        finishEditingButton.enabled = false
        let userInfo = sender.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        if activeTextView != availabilityTextView && activeTextField != firstNameTextField &&
            activeTextField != lastNameTextField {
            showKeyBoard(offset, keyboardSize: keyboardSize)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    //hide keyboard on background tap
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    
    func dismissViewController(user: User) {
        delegate?.editMyProfileViewController(self, didFinishEditingProfile: user)
    }
    
    //----------------Private Methods--------------------
    
    private func registerDelegateForInputFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        availabilityTextView.delegate = self
        nicknameTextField.delegate = self
        cityTextField.delegate = self
    }
    
    /* Place appropriate contacts in correct text field when the view load */
    private func matchInitialContactsValues() {
        for contact in allContacts {
            switch contact.type! {
            case ContactType.Phone.label:
                HubUtility.putContactsInAppropriateTextfield(contact, contacts: phoneContacts)
            case ContactType.Email.label:
                HubUtility.putContactsInAppropriateTextfield(contact, contacts: emailContacts)
            case ContactType.Address.label:
                HubUtility.putContactsInAppropriateTextfield(contact, contacts: addressContacts)
            case ContactType.Social.label:
                HubUtility.putContactsInAppropriateTextfield(contact, contacts: socialContacts)
            default:
                break
            }
        }
    }
    
    private func showKeyBoard(offset: CGSize, keyboardSize: CGSize) {
        UIView.animateWithDuration(0.1, animations: {
            () -> Void in
            if keyboardSize == offset {
                if self.view.frame.origin.y == self.viewInitialPointOfOrigin {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            } else {
                self.view.frame.origin.y += keyboardSize.height - offset.height
            }
        })
    }
}

