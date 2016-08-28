//
//  MenuTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/10/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var barcodeView: UIImageView!
    var selectedIndexPath: NSIndexPath!
    var user: User = (Helpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.selectRowAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
        barcodeView.image = UIImage(data: user.barcodeData)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath == selectedIndexPath {
            // Hide the table view instead
            self.revealViewController().revealToggleAnimated(true)
            return nil
        } else {
            // Move the selected indexpath
            selectedIndexPath = indexPath
            return indexPath
        }
    }
}
