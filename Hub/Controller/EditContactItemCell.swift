//  EditContactItemCell.swift
//  Hub
//  Created by Alexei Gudimenko on 11/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class EditContactItemCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactInputTextField: UITextField!
    var contact: Contact?

    override func awakeFromNib() {
        super.awakeFromNib()
        initialiseTextField()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureKeyboardForContactType(contactType: Int) {
        switch contactType {
        case 1:
            contactInputTextField.keyboardType = .PhonePad
        case 2:
            contactInputTextField.keyboardType = .EmailAddress
        default:
            contactInputTextField.keyboardType = .ASCIICapable
        }
    }

    func initialiseTextField() {
        contactInputTextField.delegate = self
    }
    
    //If the user presses the 'return' key, hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
