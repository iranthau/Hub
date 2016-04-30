//  ContactShareCellDelegate.swift
//  Hub
//  Created by Irantha Rajakaruna on 20/02/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation

protocol ContactShareCellDelegate: class {
    func switchStateChanged(sender: AnyObject, isOn: Bool)
}