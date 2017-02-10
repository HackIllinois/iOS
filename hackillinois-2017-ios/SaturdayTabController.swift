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
            let location_id = arc4random_uniform(4)
            let location_names = [
                "DCL",
                "Siebel",
                "ECEB",
                "Union"
            ]
            
            let item = DayItem(
                name: "Saturday Event \(n)",
                location: location_names[Int(location_id)],
                time: "MM:DD PM",
                description: "Description here. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. ",
                highlighted: arc4random_uniform(2) == 0,
                location_id: Int(location_id) + 1
            )
            tableView.dayItems.append(item)
        }
        
        reloadTableData()
    }
}
