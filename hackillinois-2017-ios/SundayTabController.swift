//
//  SundayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class SundayTabController: GenericTabController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initIndex()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initIndex()
    }
    
    func initIndex(){
        dayIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sunday
        for n in 0..<10 {
            let location_id = Int(arc4random_uniform(4))
            let location_names = [
                "DCL",
                "Siebel",
                "ECEB",
                "Union"
            ]
            
            let item = DayItem(
                name: "Sunday Event \(n)",
                time: "MM:DD PM",
                description: "Description here. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. This is a long description. ",
                highlighted: arc4random_uniform(2) == 0,
                locations: [
                    DayItemLocation(id: location_id + 1, name: location_names[location_id])
                ]
            )
            tableView.dayItems.append(item)
        }
        
        reloadTableData()
    }
}
