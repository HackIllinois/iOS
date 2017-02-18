//
//  HomeViewController.swift
//  hackillinois-2017-ios
//
//  Created by Tommy Yu on 12/28/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - ENUMS
    enum HackathonStatus {
        case beforeHackathon
        case beforeHacking
        case duringHacking
        case afterHackathon
        
        static var current: (HackathonStatus, TimeInterval) {
            let currentTime = Date().timeIntervalSince1970
            var status: HackathonStatus
            if currentTime < HACKATHON_BEGIN_TIME {
                status = .beforeHackathon
            } else if currentTime  > HACKATHON_BEGIN_TIME && currentTime < HACKING_BEGIN_TIME {
                status = .beforeHacking
            } else if currentTime > HACKING_END_TIME {
                status = .duringHacking
            } else {
                status = .afterHackathon
            }
            return (status, currentTime)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var checkInTableView: UITableView!
    
    
    // MARK: - Global Variables
    var events = [Feed]()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInTableView.sectionHeaderHeight = 0.0
        checkInTableView.sectionFooterHeight = 0.0
        
        checkInTableView.rowHeight = UITableViewAutomaticDimension
        checkInTableView.estimatedRowHeight = 200
        
        // This creates dummy data
        loadSavedData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // remove the functions that were added such as those that refresh the tableview and fetch new data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let _ = appDelegate.clearIntereval(key: "HomeViewController")
        let _ = appDelegate.clearIntereval(key: "HomeViewRefresh")
        print("HomeView popped")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // the funcList holds the refresh function of this instance so that appdelegate can refresh the tableview and fetch new data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInterval(key: "HomeViewController", callback: loadSavedData)
        appDelegate.setInterval(key: "HomeViewRefresh", callback: refreshTableView)


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HackathonStatus.current.0 {
        case .beforeHackathon:
            return 1
        case .beforeHacking:
            return events.count + 1
        case .duringHacking:
            return events.count + 1
        case .afterHackathon:
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        if let eventDetails = storyboard.instantiateViewController(withIdentifier: "EventDetailsView") as? EventDetailsViewController {
            eventDetails.eventDetails = events[indexPath.row - 1];
            navigationController?.pushViewController(eventDetails, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        switch indexPath.row {
        case 0:
            
            switch HackathonStatus.current.0 {
                
            case .beforeHackathon:
                return tableView.dequeueReusableCell(withIdentifier: "beforeHackathon", for: indexPath)
                
            case .beforeHacking:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beforeOrDuringHacking", for: indexPath)
                if let cell = cell as? mainCell {
                    // initalize the timer label as current time and decrement by 1 second every second
                    cell.timeRemaining = HACKING_BEGIN_TIME - HackathonStatus.current.1
                    cell.timeStart()
                }
                return cell
                
                
            case .duringHacking:
                let cell = tableView.dequeueReusableCell(withIdentifier: "beforeOrDuringHacking", for: indexPath)
                if let cell = cell as? mainCell {
                    // initalize the timer label as current time and decrement by 1 second every second
                    cell.timeStart()
                }
                return cell
                
                
            case .afterHackathon:
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
                
                if let cell = cell as? mainCell {
                    // initalize the timer label as current time and decrement by 1 second every second
                    cell.timeStart()
                }
                return cell
                
                
            }
           
            
        default:
            // THIS IS FOR EVENT CELLS
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath)
            if let cell = cell as? mainCell {
                cell.eventLabel?.text = events[indexPath.row - 1].name
                cell.checkinTimeLabel?.text = dateFormatter.string(from: events[indexPath.row - 1].startTime)
//                cell.qrCodeButton.roundedButton()
            }
            return cell
        }
    }
    
    
    /* called when qr code button is clicked */
    func buttonClicked() {
        let profilePageIndex = 3
        self.tabBarController?.selectedIndex = profilePageIndex
    }
    
    /* called when location label is clicked */
    func locationClicked(_ sender: UITapGestureRecognizer) {
        openLocation((sender.view as! UILabel).text!)
    }
    
    /* loads saved data from the SQL storage on local device and not the web */
    func loadSavedData(){
        print ("load saved data called")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        
        // load only events that are upcoming
        fetchRequest.predicate = NSPredicate(format: "startTime > %@", NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]

        if let feedArr = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            events = feedArr
        } else {
            events = []
        }
        checkInTableView.reloadData()
    }

    func refreshTableView() {
        self.checkInTableView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
    }
    
    // initializing dummy data
    func initializeSample(){
        
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 1, location: "Thomas M. Siebel Center", abbreviation: "Siebel",locationLatitude: 40.113926, locationLongitude: -88.224916, locationFeeds: nil)
        
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 2, location: "Electrical Computer Engineering Building", abbreviation: "ECEB", locationLatitude: 40.114828, locationLongitude: -88.228049, locationFeeds: nil)
        
        let union: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 3, location: "Illini Union", abbreviation: "Union", locationLatitude: 40.109395, locationLongitude: -88.227181, locationFeeds: nil)
        
        let date = Date(timeIntervalSince1970: 1487107800)

        _ = CoreDataHelpers.createOrFetchFeed(id: 421, description: "test", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel], tag: "EVENT")
        
        _ = CoreDataHelpers.createOrFetchFeed(id: 422, description: "test", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, union], tag: "EVENT")
        _ = CoreDataHelpers.createOrFetchFeed(id: 423, description: "test", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, eceb, union], tag: "EVENT")
        _ = CoreDataHelpers.createOrFetchFeed(id: 424, description: "test", startTime: date, endTime: date, updated: date, qrCode: 1, shortName: "tt", name: "test event", locations: [siebel, eceb], tag: "EVENT")
        
         CoreDataHelpers.saveContext()
    }
    
    /* opens the appropriate map view according to the location text */
    func openLocation(_ location_name: String) {
        // dictionary that correlates the name of the location to location id used by maps view
        let locations: [String:Int] = [
            "DCL" : 1,
            "Digital Computer Laboratory": 1,
            "Thomas M. Siebel Center" : 2,
            "Siebel" : 2,
            "Thomas Siebel Center" : 2,
            "ECEB" : 3,
            "Electrical Computer Engineering Building" : 3,
            "Union" : 4,
            "Illini Union" : 4

        ]
        let location_id = locations[location_name]
        if let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "Map") as? MapViewController {
            vc.labelPressed = location_id!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    


}
