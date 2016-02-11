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

    
    // #warning: this object is simply a test object to enable functionality 
    //  testing. Replace this with correct content from the model when the 
    //  relevant bits of functionality are merged. (Subject to pull request) - A. G.
    let testData = MyProfileTestData()
    
    var activeDataSource:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorColor = UIColor(red: 255/255.0, green: 255/255.0,
            blue: 255/255.0, alpha: 0.0)
        // Do any additional setup after loading the view.
        // TODO: replace test values with content from model
        title = testData.userFirstName + " " + testData.userLastName
        
        // Make image view circular and set it to image from model:
        profileImageView.image = UIImage(named: testData.userImageName)
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        nicknameLabel.text = "☞ " + testData.userNickname
        cityLocationLabel.text = "📍 " + testData.userCity
        
        // Display phone numbers by default:
        activeDataSource = testData.phoneNumberTestData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneButtonPressed() {
        activeDataSource = testData.phoneNumberTestData
        print("***Phone button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func emailButtonPressed() {
        activeDataSource = testData.emailTestData
        print("***Email button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func addressButtonPressed() {
        activeDataSource = testData.addressTestData
        print("***Address button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    @IBAction func socialButtonPressed() {
        activeDataSource = testData.socialTestData
        print("***Social button pressed; count of items in array: \(activeDataSource.count)")
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditProfile" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! EditMyProfileViewController
            
            controller.doneIsEnabled = false
            // #warning: replace with model data!
            controller.userData = testData
        }
    }
    

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