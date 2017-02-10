//
//  FridayTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class FridayTabController: GenericTabController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initIndex()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initIndex()
    }
    
    func initIndex(){
        dayIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Friday
        for n in 0..<10 {
            let item = DayItem(name: "Friday Event \(n)", location: "REPLACE ME", time: "MM:DD PM", description: "Description here. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. ", highlighted: arc4random_uniform(2) == 0)
            tableView.dayItems.append(item)
        }
        
        reloadTableData()
    }
}
