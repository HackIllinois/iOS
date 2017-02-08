//
//  SaturdayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class SaturdayTabController: GenericTabController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initIndex()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initIndex()
    }
    
    func initIndex(){
        dayIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Saturday

        for n in 0..<10 {
            let item = DayItem(name: "Saturday Event \(n)", location: "REPLACE ME", time: "MM:DD PM", description: "Description here.", highlighted: arc4random_uniform(2) == 0)
            tableView.dayItems.append(item)
        }
        
        reloadTableData()
    }
}
