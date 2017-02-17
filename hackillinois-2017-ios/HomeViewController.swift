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
    
    @IBOutlet weak var checkInTableView: UITableView!
    var currentTimeForTable = Int(NSDate().timeIntervalSince1970)
    
    let MAIN_CELL_HEIGHT                 = 332
    let STANDARD_CELL_HEIGHT             = 179
    let TWO_LOCATIONS_CELL_HEIGHT        = 215
    let THREE_LOCATIONS_CELL_HEIGHT      = 251
    let NO_EVENT_CELL_HEIGHT             = 120
    let MAIN_CELL_AFTER_HACKATHON_HEIGHT = 437
    
    var events = [Feed]()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print (HACKATHON_BEGIN_TIME)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentTimeForTable < HACKATHON_BEGIN_TIME) {
            return 2 // one for main cell before hackathon and one for no event cell
        } else if(currentTimeForTable > HACKATHON_BEGIN_TIME && currentTimeForTable < HACKING_END_TIME) {
            return events.count + 1 // number of events and the main cell
        }
        return 1 // otherwise just return the goodbye cell
        
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
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         // first cell should always be the main cell
//        currentTimeForTable = Int(NSDate().timeIntervalSince1970)
//        print(currentTimeForTable)
//        print (events)
//        print ("table view called with index path " + String(indexPath.row))
//        if (indexPath.row == 0) {
//            if(currentTimeForTable < HACKATHON_BEGIN_TIME) { // if the hackathon has not started yet
//                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellBeforeHackathonCell", for: indexPath)
//                cell.backgroundColor = UIColor.clear
//                cell.isUserInteractionEnabled = false;
//                return cell
//            } else if (currentTimeForTable  > HACKATHON_BEGIN_TIME && currentTimeForTable < HACKING_BEGIN_TIME) { // if the hackathon has started but hacking has not
//                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellBeforeHacking", for: indexPath) as! mainCellBeforeHacking
//                cell.backgroundColor = UIColor.clear
//                cell.selectionStyle = .none
//                cell.isUserInteractionEnabled = false;
//                
//                // initalize the timer label as current time and decrement by 1 second every second
//                cell.timeRemaining = HACKING_BEGIN_TIME - currentTimeForTable
//                cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
//                cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
//                cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
//                cell.hoursLabel.text = cell.hoursLeft.description
//                cell.minutesLabel.text = cell.minutesLeft.description
//                cell.secondsLabel.text = cell.secondsLeft.description
//                cell.mTimer.invalidate()
//                cell.timeStart()
//        
//                return cell
//            } else if (currentTimeForTable > HACKING_END_TIME) { // if the hackathon has ended
//                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellAfterHackathon", for: indexPath)
//                cell.isUserInteractionEnabled = false;
//                cell.backgroundColor = UIColor.clear
//                return cell
//            } else {// otherwise we're hacking currently
//                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
//                cell.selectionStyle = .none
//                cell.backgroundColor = UIColor.clear
//                cell.isUserInteractionEnabled = false;
//            
//                // initalize the timer label as current time and decrement by 1 second every second
//                cell.timeRemaining = HACKING_END_TIME - currentTimeForTable
//                cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
//                cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
//                cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
//                cell.hoursLabel.text = cell.hoursLeft.description
//                cell.minutesLabel.text = cell.minutesLeft.description
//                cell.secondsLabel.text = cell.secondsLeft.description
//                cell.mTimer.invalidate()
//                cell.timeStart()
//                
//                return cell
//            }
//        } else if(indexPath.row == 1 && currentTimeForTable < HACKATHON_BEGIN_TIME) { // if hackathon has not started yet
//            let cell = tableView.dequeueReusableCell(withIdentifier: "noEventCell", for: indexPath) as! noEventCell
//            cell.isUserInteractionEnabled = false;
//            cell.backgroundColor = UIColor.clear
//            return cell
//        } else if (events.count > 0 && events[indexPath.row - 1].locations.count == 1){ // we're hacking so show events
//            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath) as! standardCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = UIColor.clear
//            
//            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].startTime)
//            
//            // location clicked should go to maps view
//            let pressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
//            let tempLocations = events[indexPath.row - 1].locations.value(forKey: "name")
//            
//            cell.locationLabel.isUserInteractionEnabled = true
//            cell.locationLabel.text = (tempLocations as AnyObject).firstObject as! String?
//            cell.locationLabel.addGestureRecognizer(pressGestureRecognizer)
//
//            // button clicked should go to profile page
//            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
//            cell.qrCodeButton.roundedButton()
//            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)
//            
//            return cell
//        } else if (events.count > 0 && events[indexPath.row - 1].locations.count == 2){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "twoLocationsCell", for: indexPath) as! twoLocationsCell
//            cell.backgroundColor = UIColor.clear
//            cell.selectionStyle = .none
//            
//            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].startTime)
//            
//            // location clicked should go to maps view
//            // each label gets its own gesture recognizer
//            let firstPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
//            let secondPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
//            let tempLocations = events[indexPath.row - 1].locations.value(forKey: "name")
//            
//            cell.firstLocationLabel.text = (tempLocations as AnyObject).object(at: 0) as? String
//            cell.secondLocationLabel.text = (tempLocations as AnyObject).object(at: 1) as? String
//            
//            cell.firstLocationLabel.addGestureRecognizer(firstPressGestureRecognizer)
//            cell.secondLocationLabel.addGestureRecognizer(secondPressGestureRecognizer)
//            
//            cell.firstLocationLabel.isUserInteractionEnabled = true
//            cell.secondLocationLabel.isUserInteractionEnabled = true
//
//            // button clicked should go to profile page
//            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
//            cell.qrCodeButton.roundedButton()
//            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)
//            return cell
//        } else if((events.count > 0 && events[indexPath.row - 1].locations.count == 3)) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "threeLocationsCell", for: indexPath) as! threeLocationsCell
//            cell.backgroundColor = UIColor.clear
//            cell.selectionStyle = .none
//        
//            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].startTime)
//        
//            // location clicked should go to maps view
//            // each label gets its own gesture recognizer
//            let firstPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
//            let secondPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
//            let thirdPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
//            let tempLocations = events[indexPath.row - 1].locations.value(forKey: "name")
//        
//            cell.firstLocationLabel.text = (tempLocations as AnyObject).object(at: 0) as? String
//            cell.secondLocationLabel.text = (tempLocations as AnyObject).object(at: 1) as? String
//            cell.thirdLocationLabel.text = (tempLocations as AnyObject).object(at: 2) as? String
//    
//            cell.firstLocationLabel.addGestureRecognizer(firstPressGestureRecognizer)
//            cell.secondLocationLabel.addGestureRecognizer(secondPressGestureRecognizer)
//            cell.thirdLocationLabel.addGestureRecognizer(thirdPressGestureRecognizer)
//            
//            cell.firstLocationLabel.isUserInteractionEnabled = true
//            cell.secondLocationLabel.isUserInteractionEnabled = true
//            cell.thirdLocationLabel.isUserInteractionEnabled = true
//        
//            // button clicked should go to profile page
//            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
//            cell.qrCodeButton.roundedButton()
//            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)
//            return cell
//        }
//        // ideally we should never get here
//        let cell = tableView.dequeueReusableCell(withIdentifier: "noEventCell", for: indexPath) as! noEventCell
//        cell.isUserInteractionEnabled = false;
//        cell.backgroundColor = UIColor.clear
//        return cell
//    }
    
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
        print ("refresh table view called")
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
