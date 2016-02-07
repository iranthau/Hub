//
//  MyProfileViewController.swift
//  Hub
//
//  Created by Alexei Gudimenko on 7/02/2016.
//  Copyright © 2016 88Software. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    //outlet vars:
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var cityLocationLabel: UILabel!
    @IBOutlet weak var contactHoursDetail: UILabel!
    @IBOutlet weak var phoneContactButton: UIButton!
    @IBOutlet weak var emailContactButton: UIButton!
    @IBOutlet weak var addressContactButton: UIButton!
    @IBOutlet weak var socialContactButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    
    //view set-up variables: use test values, replace with values from data model
    //let thisUser: User?
    
    var phoneNumberTestData = [
        "0421433433",
        "0431623946"
    ]
    
    var emailTestData = [
        "whispering.gloom@live.com.au",
        "alexei.gudimenko@gmail.com",
        "spear.of.longinus@gmx.com"
    ]
    
    var addressTestData = [
        "92, Wilson St, Cheltenham",
        "2, Alvina Crt, Frankston",
        "811, Princes Hwy, Springvale",
        "1, Flinders St, Melbourne"
    ]
    
    var activeDataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // TODO: replace test values with content from model
        title = "John Smith"
        
        // Make image view circular and set it to image from model:
        profileImageView.image = UIImage(named: "mona_cthulu")
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneButtonPressed() {
        activeDataSource = phoneNumberTestData
        print("***Phone button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        activeDataSource = emailTestData
        print("***Email button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        activeDataSource = addressTestData
        print("***Address button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
 UITableView Data Source and Delegate methods. The table view is used to display a list of user's contact
  points of a given type (e.g. phone, email, etc. ). Which type is displayed is determined by whichever
  button is pressed on the UI. There are four buttons, one for each type of contact; tapping each one will
  set which data source the table view will use.
*/

extension MyProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDataSource.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "ContactItemCell"
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                forIndexPath: indexPath) as! ContactItemCell
            
            let label = cell.viewWithTag(88) as! UILabel
            label.text = activeDataSource[indexPath.row]
            print("***Text in label:" + label.text!)
            
        return cell
    }
}

extension MyProfileViewController: UITableViewDelegate {
    
}