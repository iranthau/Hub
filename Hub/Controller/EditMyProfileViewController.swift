//
//  EditMyProfileViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 11/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit
import Parse

protocol EditMyProfileViewControllerDelegate: class {
    func editMyProfileViewControllerDidCancel(controller: EditMyProfileViewController)
    func editMyProfileViewController(controller: EditMyProfileViewController, didFinishEditingProfile userProfile: User)
}

class EditMyProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var availabilityTextField: UITextView!
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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageChangeButton: UIButton!
    @IBOutlet weak var selectedContactColor: UIView!
    
    weak var delegate: EditMyProfileViewControllerDelegate?
    var contactFieldCell: EditContactItemCell?
    var activeTextField: UITextField?
    let defaultViewFrameOriginY: CGFloat = 64.0 //point at the bottom of the nav bar
    
    var currentUser: User?
    let hubModel = HubModel.sharedInstance
    var profileImage: UIImage?
    var activeDataSource = [Contact]()
    var keyboardForContactType = 0
    var doneIsEnabled = false
    
    var allContacts = [Contact]()
    var phoneContacts = [Contact]()
    var emailContacts = [Contact]()
    var addressContacts = [Contact]()
    var socialContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        currentUser = hubModel.currentUser
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        let pObject = PFObject(className: "Contact")
        phoneContacts = hubModel.initialisePhoneContacts(pObject)
        emailContacts = hubModel.initialiseEmailContacts(pObject)
        addressContacts = hubModel.initialiseAddressContacts(pObject)
        socialContacts = hubModel.initialiseSocialContacts(pObject)
        
        activeDataSource = phoneContacts

        if let currentUser = currentUser {
            doneNavBarButton.enabled = true
            firstNameTextField.text = currentUser.firstName
            lastNameTextField.text = currentUser.lastName
            nicknameTextField.text = currentUser.nickname
            if currentUser.availableTime == nil {
                availabilityTextField.text = "When can others contact you"
            } else {
                availabilityTextField.text = currentUser.availableTime
            }
            
            let imageFile = currentUser.profileImage
            imageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profileImageView.image = UIImage(data:imageData)
                    }
                }
            }
            allContacts = currentUser.contacts
        }
        
        matchInitialContactsValues()
        
        // assign delegates and keyboard types to regular text fields
        initialiseTextFields()
        
        selectedContactColor.backgroundColor = UIColor(red: 240/255.0, green: 148/255.0,
                                                      blue: 27/255.0, alpha: 1)
        
        //move content higher when a text field is selected:
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMyProfileViewController.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMyProfileViewController.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func matchInitialContactsValues() {
        for contact in allContacts {
            switch contact.type! {
            case ContactType.Phone.label:
                for c in phoneContacts {
                    if c.subType == contact.subType {
                        c.value = contact.value
                    }
                }
            case ContactType.Email.label:
                for c in emailContacts {
                    if c.subType == contact.subType {
                        c.value = contact.value
                    }
                }
            case ContactType.Address.label:
                for c in addressContacts {
                    if c.subType == contact.subType {
                        c.value = contact.value
                    }
                }
            case ContactType.Social.label:
                for c in socialContacts {
                    if c.subType == contact.subType {
                        c.value = contact.value
                    }
                }
            default:
                break
            }
        }
    }
    
    //Assign a delegate to the main text fields so that they can respond to events in the
    // UI, such as user tapping a return button
    func initialiseTextFields() {
        availabilityTextField.keyboardType = .Default
        firstNameTextField.keyboardType = .Default
        lastNameTextField.keyboardType = .Default
        nicknameTextField.keyboardType = .Default
    }

    //cancel editing: dismiss view controller
    @IBAction func cancel() {
        delegate?.editMyProfileViewControllerDidCancel(self)
    }
    
    //done editing: set new values, dismiss view controller
    @IBAction func done() {
        
        if let userData = userData {
            userData.userFirstName = firstNameTextField.text!
            userData.userLastName = lastNameTextField.text!
            userData.userNickname = nicknameTextField.text!
            userData.userAvailability = availabilityTextField.text!
//            userData.userImage = profileImage
            delegate?.editMyProfileViewController(self, didFinishEditingProfile: userData)
        }
    }
    
    @IBAction func phoneButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.phoneNumberTestData
            keyboardForContactType = 1
            activeContactImage = UIImage(named: "phone")!
        }
        
        contactFieldTableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.emailTestData
            keyboardForContactType = 2
            activeContactImage = UIImage(named: "email-other")!
        }
        
        contactFieldTableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        //TODO: set active data source, set keyboard type, reload tableView data
        if let user = userData {
            activeDataSource = user.addressTestData
            keyboardForContactType = 3
            activeContactImage = UIImage(named: "address-other")!
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

    //handle profile image change:
    @IBAction func changeProfileImage() {
        pickPhoto()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: implement the cell configuration and allow user to edit content in cells
        let cell = tableView.dequeueReusableCellWithIdentifier("EditContactCell") as! EditContactItemCell
        
        let textField = cell.contactInputTextField
        textField.delegate = self
        textField.text = activeDataSource[indexPath.row].value
        textField.placeholder = activeDataSource[indexPath.row].subType
        let imageName = activeDataSource[indexPath.row].getImageName()
        cell.contactImage.image = UIImage(named: imageName)
        cell.configureKeyboardForContactType(keyboardForContactType)
        cell.contact = activeDataSource[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditContactItemCell
        let textField = cell.contactInputTextField
        activeDataSource[indexPath.row].value = textField.text!
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension EditMyProfileViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

//keyboard show/hide handling
extension EditMyProfileViewController {
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
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let _: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y = defaultViewFrameOriginY
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        if activeTextField != availabilityTextField && activeTextField != firstNameTextField &&
            activeTextField != lastNameTextField {
        if keyboardSize == offset {
            if self.view.frame.origin.y == defaultViewFrameOriginY {
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
}

//MARK: - photo picker extension
extension EditMyProfileViewController:
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
        let imagePicker = CustomImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileImage = info[UIImagePickerControllerEditedImage] as? UIImage
        profileImageView.image = profileImage 
//        if let user = userData{
//           user.userImageName = (info[UIImagePickerControllerEditedImage]?.key)!
//        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil,
            preferredStyle: .ActionSheet)
        //ActionSheet is similar to normal AlertController, except it slides up
        // from the bottom of the screen.
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo",
            style: .Default, handler: { _ in self.takePhotoWithCamera()})
        
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library",
            style: .Default, handler: { _ in self.choosePhotoFromLibrary()})
        
        alertController.addAction(chooseFromLibraryAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

