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

    let hackathonBeginTime = 0;
    let hackingBeginTime = 0;
    let hackingEndTime = 0;
    let hackathonEndTime = 0;
    var currentTimeForTable = 9999999999999999;
    
    var events : [Feed] = [];
    
    
    @IBOutlet weak var checkInTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTimeForTable = Int(NSDate().timeIntervalSince1970)
        UIApplication.shared.statusBarStyle = .lightContent;
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        self.view.insertSubview(backgroundImage, at: 0)
        
        checkInTableView.delegate = self
        checkInTableView.dataSource = self
        
        checkInTableView.separatorStyle = .none;
        checkInTableView.backgroundColor = UIColor.clear
        checkInTableView.showsVerticalScrollIndicator = false;
        checkInTableView.sectionHeaderHeight = 0.0;
        checkInTableView.sectionFooterHeight = 0.0;
        initializeSample();
        loadSavedData();
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentTimeForTable < hackathonBeginTime) {
            return 2;
        } else if(currentTimeForTable > hackathonBeginTime && currentTimeForTable < hackathonEndTime) {
            return events.count + 1;
        }
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            if(currentTimeForTable > hackathonEndTime) {
                return 446;
            }
            return 332;
        }
        else if(indexPath.row == 1 && currentTimeForTable < hackathonBeginTime) {
            return 120;
        } else if(events[indexPath.row - 1].locations?.count == 1) {
            return 179;
        } else if(events[indexPath.row - 1].locations?.count == 2) {
            return 215;
        } else {
            return 251;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        if let eventDetails = storyboard.instantiateViewController(withIdentifier: "EventDetails") as? EventDetailsViewController {
            navigationController?.pushViewController(eventDetails, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // first cell should always be the main cell
        if (indexPath.row == 0) {
            if(currentTimeForTable < hackathonBeginTime) { // if the hackathon has not started yet
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellBeforeHackathonCell", for: indexPath) as! mainCellBeforeHackathonCell
                cell.backgroundColor = UIColor.clear;
                return cell;
            } else if (currentTimeForTable > hackathonBeginTime && currentTimeForTable < hackingBeginTime) { // if the hackathon has started but hacking has not
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellBeforeHacking", for: indexPath) as! mainCellBeforeHacking
                 let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
                cell.selectionStyle = .none;
                cell.timeRemaining = cell.eventStartUnixTime - currentUnixTime
                cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
                cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
                cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
                cell.hoursLabel.text = cell.hoursLeft.description;
                cell.minutesLabel.text = cell.minutesLeft.description;
                cell.secondsLabel.text = cell.secondsLeft.description;
                cell.backgroundColor = UIColor.clear;
                cell.mTimer.invalidate();
                cell.timeStart();
                cell.backgroundColor = UIColor.clear;
                return cell;
            } else if (currentTimeForTable > hackathonEndTime) { // if the hackathon has ended
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellAfterHackathon", for: indexPath) as! mainCellAfterHackathon
                cell.backgroundColor = UIColor.clear;
                return cell;
            } // otherwise we're hacking currently
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
            let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
            cell.selectionStyle = .none;
            cell.timeRemaining = cell.eventStartUnixTime - currentUnixTime
            cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
            cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
            cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
            cell.hoursLabel.text = cell.hoursLeft.description;
            cell.minutesLabel.text = cell.minutesLeft.description;
            cell.secondsLabel.text = cell.secondsLeft.description;
            cell.backgroundColor = UIColor.clear;
            cell.mTimer.invalidate();
            cell.timeStart();
            return cell;
        } else if(indexPath.row == 1 && currentTimeForTable < hackathonBeginTime) { // if hackathon has not started yet
            let cell = tableView.dequeueReusableCell(withIdentifier: "noEventCell", for: indexPath) as! noEventCell
            cell.backgroundColor = UIColor.clear;
            return cell;
        } else if (events[indexPath.row - 1].locations?.count == 1){ // we're hacking so show events
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath) as! standardCell
            print(events[indexPath.row - 1].time)
            let dateFormatter = DateFormatter();
            cell.selectionStyle = .none;
            
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am";
            dateFormatter.pmSymbol = "pm";
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].time)
            
            print(events.count);
            print(events[indexPath.row - 1].locations!)
            print("111111");
            let tempLocations = events[indexPath.row - 1].locations!.value(forKey: "name")
            print(tempLocations)
            cell.locationLabel.text = (tempLocations as AnyObject).firstObject as! String?;

            cell.backgroundColor = UIColor.clear
            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
            cell.qrCodeButton.roundedButton();
            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)

            return cell;
        } else if (events[indexPath.row - 1].locations?.count == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoLocationsCell", for: indexPath) as! twoLocationsCell
            let dateFormatter = DateFormatter();
            cell.selectionStyle = .none;
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am";
            dateFormatter.pmSymbol = "pm";
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].time)
            
            print(events.count);
            print(events)
            print("2222222");
            print(indexPath.row);
            
            let tempLocations = events[indexPath.row - 1].locations!.value(forKey: "name")
            print(tempLocations)
            cell.firstLocationLabel.text = (tempLocations as AnyObject).object(at: 0) as? String;
            cell.secondLocationLabel.text = (tempLocations as AnyObject).object(at: 1) as? String;

            

            cell.backgroundColor = UIColor.clear
            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
            cell.qrCodeButton.roundedButton();
            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)

            return cell;
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeLocationsCell", for: indexPath) as! threeLocationsCell
            let dateFormatter = DateFormatter();
            cell.selectionStyle = .none;
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am";
            dateFormatter.pmSymbol = "pm";
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].time)
        
            print(events.count);
            print(events)
            print("33333333");
            print(indexPath.row);
        
            let tempLocations = events[indexPath.row - 1].locations!.value(forKey: "name")
            print(tempLocations)
            cell.firstLocationLabel.text = (tempLocations as AnyObject).object(at: 0) as? String;
            cell.secondLocationLabel.text = (tempLocations as AnyObject).object(at: 1) as? String;
            cell.thirdLocationLabel.text = (tempLocations as AnyObject).object(at: 2) as? String;
        
            cell.backgroundColor = UIColor.clear
            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
            cell.qrCodeButton.roundedButton();
            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)
            return cell;
        
    }
    
    func buttonClicked() {
        self.tabBarController?.selectedIndex = 3;
    }
    
    func locationClicked() {
        self.tabBarController?.selectedIndex = 2;
    }
    
    func goToProfile(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = storyboard.instantiateInitialViewController();
        self.view.addSubview((profileViewController?.view)!)
        
    }
    
    func loadSavedData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        
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
        
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(location: "Thomas M. Siebel Center", abbreviation: "Siebel",locationLatitude: 40.113926, locationLongitude: -88.224916, address: "Thomas M. Siebel Center\n201 N Goodwin Ave\nUrbana, IL 61801\nUnited States", locationFeeds: nil)
        
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(location: "Electrical Computer Engineering Building", abbreviation: "ECEB", locationLatitude: 40.114828, locationLongitude: -88.228049, address: "Electrical Computer Engineering Building\n306 N Wright St\nUrbana, IL 61801\nUnited States",locationFeeds: nil)
        
        let union: Location! = CoreDataHelpers.createOrFetchLocation(location: "Illini Union", abbreviation: "Union", locationLatitude: 40.109395, locationLongitude: -88.227181, address: "Illini Union\n1401 W Green St\nUrbana, IL 61801\nUnited States", locationFeeds: nil)
        
        let tagEvent = CoreDataHelpers.createOrFetchTag(tag: "Event", feeds: nil)

        _ = CoreDataHelpers.createFeed(id: 422, message: "test", timestamp: 1486741209 , locations: [siebel], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 423, message: "test", timestamp: 1486741109 , locations: [siebel, eceb], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 424, message: "test", timestamp: 1486711109 , locations: [siebel, eceb, union], tags: [tagEvent])
        _ = CoreDataHelpers.createFeed(id: 425, message: "test", timestamp: 1486741123 , locations: [siebel], tags: [tagEvent])
        
        
        CoreDataHelpers.saveContext();
    }
    


}
