//  AboutViewController.swift
//  Hub
//  Created by Alexei Gudimenko on 20/12/2015.
//  Copyright © 2015 88Software. All rights reserved.

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func userDidCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
