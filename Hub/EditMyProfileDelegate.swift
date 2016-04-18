//
//  EditMyProfileDelegate.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 17/04/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation

protocol EditMyProfileDelegate: class {
    func editMyProfileViewControllerDidCancel(controller: EditMyProfileViewController)
    func editMyProfileViewController(controller: EditMyProfileViewController, didFinishEditingProfile userProfile: User)
}