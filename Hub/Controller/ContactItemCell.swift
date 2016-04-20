//  ContactItemCell.swift
//  Hub
//  Created by Alexei Gudimenko on 7/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import UIKit

class ContactItemCell: UITableViewCell {
    @IBOutlet weak var contactTypeImageView: UIImageView!
    @IBOutlet weak var contactDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
