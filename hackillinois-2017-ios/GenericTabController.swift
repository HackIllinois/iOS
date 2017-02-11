//
//  GenericTabControllerViewController.swift
//  hackillinois-2017-ios
//
//  Created by Derek Leung on 2017/2/4.
//  Copyright © 2017年 Shotaro Ikeda. All rights reserved.
//

import UIKit

// This class was made as a quick and easy way to reuse a view for
// three different days.
class GenericTabController: UIViewController {
    var tableView: ScheduleTableViewController!
    var dayIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableData(){
        tableView.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Store embeded table view for later uses
        if let vc = segue.destination as? ScheduleTableViewController {
            tableView = vc
            tableView.dayIndex = dayIndex
        }
    }
}
