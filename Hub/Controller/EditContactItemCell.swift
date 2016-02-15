//
//  EditContactItemCell.swift
//  Hub
//
//  Created by Alexei Gudimenko on 11/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class EditContactItemCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var contactTypeImageView: UIImageView!
    @IBOutlet weak var contactInputTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialiseTextField()
//        self.accessoryType = .DetailButton
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureKeyboardForContactType(contactType: Int) {
        switch contactType {
        case 1: contactInputTextField.keyboardType = .NumberPad
        //case 1: contactInputTextField.keyboardType = .NumbersAndPunctuation
        case 2: contactInputTextField.keyboardType = .EmailAddress
        case 3: contactInputTextField.keyboardType = .Default
        case 4: contactInputTextField.keyboardType = .Twitter
        default: contactInputTextField.keyboardType = .Default
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
