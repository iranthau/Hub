//  ContactShareCell.swift
//  Hub
//  Created by Irantha Rajakaruna on 20/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class ContactShareCell: UITableViewCell {
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
