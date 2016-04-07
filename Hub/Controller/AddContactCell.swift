//
//  AddContactTableViewCell.swift
//  Hub
//
//  Created by Alexei Gudimenko on 24/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class AddContactCell: UITableViewCell {
    
    weak var cellDelegate: ContactShareCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func statusChanged(sender: UISwitch) {
        self.cellDelegate!.switchStateChanged(self, isOn: sender.on)
    }
}
