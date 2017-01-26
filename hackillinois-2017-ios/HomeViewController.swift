//
//  HomeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Tommy Yu on 12/28/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    
    
//    and so this gets loaded with data that I can then access??
//     Fetched results controller for lazy loading of cells
//    var fetchedResultsController: NSFetchedResultsController<Feed>!
    var events : [Feed] = [];
    
    @IBOutlet weak var checkInTableView: UITableView!
//    @IBOutlet weak var startsInLabel: UILabel!
//    @IBOutlet weak var timerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fromRGBHex(mainUIColor);
        UIApplication.shared.statusBarStyle = .lightContent;
        
        checkInTableView.delegate = self
        checkInTableView.dataSource = self
        
        checkInTableView.separatorStyle = .none;
        
        initializeSample();
        loadSavedData();
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count + 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // first cell should always be the main cell
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
            let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
            cell.timeRemaining = cell.eventStartUnixTime - currentUnixTime
            cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
            cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
            cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
            cell.timerLabel.text = cell.getTimeRemainingString(hoursLeft: cell.hoursLeft, minutesLeft: cell.minutesLeft, secondsLeft: cell.secondsLeft)
            cell.timerLabel.font = UIFont(name: "Brandon_light", size: 60);
            cell.timerLabel.textColor = UIColor.fromRGBHex(textHighlightColor);
            
            cell.startsInLabel.font = UIFont(name: "Brandon_light", size: 18);
            cell.startsInLabel.textColor = UIColor.fromRGBHex(pseudoWhiteColor);
            cell.timeStart();
            return cell;
        }
        if (events[indexPath.row - 1].locations?.count == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath) as! standardCell
            print(events[indexPath.row - 1].time)
            let dateFormatter = DateFormatter();
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "mm:ss"
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].time)
            print(events.count);
            print(events[indexPath.row - 1].locations)
            print("111111");
            var tempLocations: [String] = [];
//            tempLocations = events[indexPath.row - 1].locations!.array[String];
//            cell.locationLabel.text = tempLocations[0];
            return cell;
        }
//        if (events[indexPath.row - 1].locations?.count == 2){
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoLocationsCell", for: indexPath) as! twoLocationsCell
            let dateFormatter = DateFormatter();
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "mm:ss"
            print(events.count);
            print(events)
            print("2222222");
            print(indexPath.row);
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].time)
//            var tempLocations: [String] = [];
//            tempLocations = events[indexPath.row - 1].locations!.array
//            cell.firstLocationLabel.text = tempLocations[0];
//            cell.secondLocationCell.text = tempLocations[1];
            return cell;
        }
        
        // else check the data in the events array and call the correct cell class?
    }
    
    func loadSavedData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
        fetchRequest.predicate = NSPredicate(format: "time > %@", NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        

        
        if let feedArr = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            events = feedArr
            print("SUCCESS");
        } else {
            events = []
            print("FAIL");
        }
        
        checkInTableView.reloadData()
    }
    
    func initializeSample(){
        
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(location: "Siebel", abbreviation: "Siebel",locationLatitude: 40.113926, locationLongitude: -88.224916, locationFeeds: nil)
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(location: "ECEB", abbreviation: "ECEB", locationLatitude: 40.114828, locationLongitude: -88.228049, locationFeeds: nil)
        let tagEvent = CoreDataHelpers.createOrFetchTag(tag: "Event", feeds: nil)
        
        _ = CoreDataHelpers.createFeed(id: 420, message: "test", timestamp: 14640400768, locations: [siebel], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 421, message: "test", timestamp: 14640400768, locations: [siebel, eceb], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 422, message: "test", timestamp: 14640400768, locations: [siebel], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 423, message: "test", timestamp: 14640400768, locations: [siebel, eceb], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 424, message: "test", timestamp: 14640400768, locations: [siebel], tags: [tagEvent])
        
        
        CoreDataHelpers.saveContext();
    }
    


}
