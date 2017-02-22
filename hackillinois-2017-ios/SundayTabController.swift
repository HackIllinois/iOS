//
//  SundayViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData


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

    override func viewWillAppear(_ animated: Bool) {
        // set up interval refresh
        self.updateTable()
    }
    
    func updateTable() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        
        print("Updating table...")
        if let feedArr = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            let items = feedArr.map({ (feed) -> DayItem in
                DayItem(feed: feed)
            }).filter({ (item) -> Bool in
                item.dayOfWeek == 1 // sunday
            })
            
            self.tableView.dayItems = (items as NSArray).sortedArray(using: [
                NSSortDescriptor(key: "highlighted", ascending: false),
                NSSortDescriptor(key: "timestamp", ascending: true)
                ]) as! [DayItem]
        } else {
            self.tableView.dayItems = []
        }
        self.reloadTableData()
    }
}
