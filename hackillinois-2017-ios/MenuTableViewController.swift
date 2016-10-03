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
    var selectedIndexPath: IndexPath!
    var user: User = (CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]).first!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        selectedIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        barcodeView.image = UIImage(data: user.barcodeData as Data)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == selectedIndexPath {
            // Hide the table view instead
            self.revealViewController().revealToggle(animated: true)
            return nil
        } else {
            // Move the selected indexpath
            selectedIndexPath = indexPath
            return indexPath
        }
    }
}
