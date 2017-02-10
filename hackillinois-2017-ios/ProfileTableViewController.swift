//
//  ProfileTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 7/15/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    /* User Data - Set before Controller loads via segue */
    var user: User!
    
    /* Name */
    @IBOutlet weak var nameLabel: UILabel!

    /* Organization or School */
    @IBOutlet weak var domainLabel: UILabel!
    
    @IBOutlet weak var gradCell: UITableViewCell!
    @IBOutlet weak var gradLabel: UILabel!
    
    @IBOutlet weak var majorCell: UITableViewCell!
    @IBOutlet weak var majorLabel: UILabel!
    
    @IBOutlet weak var dietLabel: UILabel!
    
    /* Professional */
    @IBOutlet weak var socialMediaCell1: UITableViewCell!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    
    @IBOutlet weak var socialMediaCell2: UITableViewCell!
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    /* Set up functions */
    func configureLabels() {
        /* Make font fit to label */
        nameLabel.adjustsFontSizeToFitWidth = true
        domainLabel.adjustsFontSizeToFitWidth = true
        gradLabel.adjustsFontSizeToFitWidth = true
        majorLabel.adjustsFontSizeToFitWidth = true 
        dietLabel.adjustsFontSizeToFitWidth = true
    }
    
    func userDataToLabel() {
        nameLabel.text = user.name
        domainLabel.text = user.school
        gradLabel.text = "May 2018"
        majorLabel.text = user.major
        dietLabel.text = "No restrictions"
    }
    
    func addButtonTargets() {
        /*
         * Add button actions to open corresponding items here
         */
        
        // TODO:
        // open resume
        // open linkedin
        // open github
        // open website
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        configureLabels()
        userDataToLabel()
        addButtonTargets()
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
