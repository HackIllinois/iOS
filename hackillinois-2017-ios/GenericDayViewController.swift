//
//  GenericDayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class GenericDayViewController: UITableViewController {
    // Items
    var dayItems: [DayItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
        
        /* Reload data */
        self.tableView.reloadData()
    }
    
    // Mark: UITableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day_cell") as! ScheduleCell
        let dayItem = dayItems[(indexPath as NSIndexPath).row]
        
        /* Initialize Cell */
        cell.title.text = dayItem.name
        cell.time.text = dayItem.time
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayItems.count
    }
}
