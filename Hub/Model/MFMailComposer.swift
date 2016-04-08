//
//  MFMailComposer.swift
//  Hub
//
//  Created by Irantha Rajakaruna on 8/04/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class MFMailComposer: NSObject, MFMailComposeViewControllerDelegate {
    var tableVC: UITableViewController
    
    init(tableVC: UITableViewController) {
       self.tableVC = tableVC
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let mailBody = "Try out new Heyya. It's awesome! Download it here http://www.ioscreator.com/"
        
        mailComposerVC.setSubject("Join Heyya")
        mailComposerVC.setMessageBody(mailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertError = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertError.addAction(defaultAction)
        
        tableVC.presentViewController(alertError, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}