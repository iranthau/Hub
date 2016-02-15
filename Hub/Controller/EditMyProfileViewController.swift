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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageChangeButton: UIButton!
    
    weak var delegate: EditMyProfileViewControllerDelegate?
    //color reference: UIColor(red: 23/255.0, green: 129/255.0,
    // blue: 204/255.0, alpha: 1.0)
    
    // this variable simulates the user data, in this case to give EditMyProfileView
    //  something to work with for functionality testing.
    //  #warning: replace with correct content from the model!!!! - A. G.
    var userData: MyProfileTestData?
    var activeDataSource = [String]()
    var keyboardForContactType: Int = 0
    var activeContactImage = UIImage()
    var doneIsEnabled = false
    
    var contactFieldCell: EditContactItemCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the separator lines in the table view
        contactFieldTableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        
        //set user's profile image to round display instead of square
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        //get the user data from the segue
        if let user = userData {
            title = "Edit " + user.userFirstName + "'s Profile"
            // perform any other additional setup of the view
            doneNavBarButton.enabled = true
            firstNameTextField.text = user.userFirstName
            lastNameTextField.text = user.userLastName
            nicknameTextField.text = user.userNickname
            profileImageView.image = UIImage(named: user.userImageName)
        }
        
        // assign delegates and keyboard types to regular text fields
        initialiseTextFields()
        
        //move content higher when a text field is selected:
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification, object: self.view.window)
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
        nicknameTextField.keyboardType = .Default
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
        let imageView = cell.contactTypeImageView
        imageView.image = activeContactImage
        
        cell.configureKeyboardForContactType(keyboardForContactType)
        
        return cell
    }
}

extension EditMyProfileViewController: UITableViewDelegate {
    //enable row deletion etc
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            // perform any data assignments etc
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //enable data deletion from contact fields
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            activeDataSource.removeAtIndex(indexPath.row)
            
            let indexPaths = [indexPath]
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    //handle tap on the accessory button
    func tableView(tableView: UITableView,
        accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            
    }
}

extension EditMyProfileViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

//keyboard show/hide handling
extension EditMyProfileViewController {
    func keyboardWillHide(sender: NSNotification) {
        print("***KeyboardWillHide")
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func keyboardWillShow(sender: NSNotification) {
        print("***KeyboardWillShow")
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
//        print("***\(self.view.frame.origin.y)")
//        self.view.frame.origin.y = 0.0
        //print("***offset: \(offset)")
        //print("***key size: \(keyboardSize)")
        if keyboardSize == offset {
            if self.view.frame.origin.y == 64.0 {
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
        let imagePicker = UIImagePickerController()
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
        profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
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

