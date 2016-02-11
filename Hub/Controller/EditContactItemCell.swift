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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
