//
//  GenericDayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController {
    @IBOutlet weak var tableTopBorder: UIView!
    
    // Items
    var dayItems: [DayItem] = []
    var dayIndex: Int = 0
    
    let highlightedCellBackgroundColor = UIColor(red: 45.0/255.0, green: 70.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    let dehighlightedCellBackgroundColor = UIColor(red: 20.0/255.0, green: 36.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create padding
        self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 12, 0);
        
        // create rounded corners
        self.view.layoutIfNeeded()
        roundCorners(view: tableTopBorder, corners: [.topLeft, .topRight], radius: tableTopBorder.frame.height)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        
    }
    
    func openLocation(_ location_id: Int) {
        if let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "Map") as? MapViewController {
            vc.labelPressed = location_id
            navigationController?.navigationBar.tintColor = UIColor(red: 93.0/255.0, green: 200.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            navigationController?.navigationBar.backgroundColor = UIColor(red: 28.0/255.0, green: 50.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Mark: UITableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day_cell") as! ScheduleCell
        let dayItem = dayItems[(indexPath as NSIndexPath).row]
        
        /* Initialize Cell */
        cell.cellInit()
        cell.props = dayItems[indexPath.row]
        cell.setEventContent(title: dayItem.name, time: dayItem.time, description: "Woot woot")
        cell.setHappening(dayItem.highlighted)
        
        cell.tableCall = openLocation
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ScheduleDescription") as? ScheduleDescriptionViewController {
            vc.dayItem = dayItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
}
