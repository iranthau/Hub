//  HubUtility.swift
//  Hub
//  Created by Irantha Rajakaruna on 20/04/2016.
//  Copyright © 2016 88Software. All rights reserved.

import Foundation
import UIKit
import Parse

class HubUtility {
    class func convertImageFileToParseFile(imageFile: UIImage) -> PFFile {
        let imageData = imageFile.lowQualityJPEGNSData
        return PFFile(data: imageData)!
    }
}