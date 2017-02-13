//
//  FridayTableViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/11/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

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
        
        /*
        let sampleDescStr = String(repeating: "This event contains a clickable image.\n", count: 10)
        
        // Friday
        for n in 0..<10 {
            let location_names = [
                "DCL",
                "Siebel",
                "ECEB",
                "Union"
            ]
            
            let item = DayItem(
                name: "Friday Event \(n)",
                time: "MM:DD PM",
                description: sampleDescStr,
                highlighted: arc4random_uniform(2) == 0,
                locations: []
            )
            
            let location_num = Int(arc4random_uniform(3))
            var locations = [DayItemLocation]()
            for _ in 0...location_num {
                let location_id = Int(arc4random_uniform(4))
                locations.append(
                    DayItemLocation(id: location_id + 1, name: location_names[location_id])
                )
            }
            item.locations = locations
            item.name += " " + String(location_num + 1)
            
            //let randomImageIndex = Int(arc4random_uniform(UInt32(sampleImages.count)))
            //item.imageTitle = sampleImages[randomImageIndex]["title"]
            //item.imageUrl = sampleImages[randomImageIndex]["url"]
            item.setImage(title: "Test Image", fileName: "test_img")
            tableView.dayItems.append(item)
        }
        
        reloadTableData()
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set up interval refresh
        self.registerReloadFunction()
        self.updateTable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.unregisterReloadFunction()
    }
    
    
    func registerReloadFunction() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInterval(key: "FridayTabController", callback: self.updateTable)
    }
    
    func unregisterReloadFunction() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let _ = appDelegate.clearIntereval(key: "FridayTabController")
    }
    
    
    func updateTable() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        
        print("Updating table...")
        if let feedArr = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            self.tableView.dayItems = feedArr.map({ (feed) -> DayItem in
                DayItem(feed: feed)
            })
        } else {
            self.tableView.dayItems = []
        }
        self.reloadTableData()
    }

}
