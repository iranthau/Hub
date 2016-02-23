//
//  Contact.swift
//  Hub
//
//  Created by Alexei Gudimenko on 22/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class Contact {
    
    var name: String
    var value: String
    var type: ContactType
    var image: UIImage = UIImage()
    var shared: Bool
    
    init() {
        name = ""
        value = ""
        type = .Home
        image = UIImage()
        shared = false
    }
    
    init(name: String, value: String, type: ContactType, imageName: String = "", shared: Bool) {
        let imageNameString = imageName
        
        self.name = name
        self.value = value
        self.type = type
        self.shared = shared
        guard imageNameString == "" else {
            self.image = UIImage(named: imageNameString)!
            return
        }
    }
}