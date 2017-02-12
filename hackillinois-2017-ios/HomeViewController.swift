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

    // TODO: Initialized to actual unix times for event status.
    let hackathonBeginTime = 0      //Change Me!
    let hackingBeginTime = 0        //Change Me!
    let hackingEndTime = Int(NSDate().timeIntervalSince1970) + 1000          //Change Me!
    let hackathonEndTime = Int(NSDate().timeIntervalSince1970) + 1000        //Change Me!
    var currentTimeForTable = 0     //Change Me!
          //Change Me!                           
    var events : [Feed] = []
    
    
    
    @IBOutlet weak var checkInTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.funcList.append(self.loadSavedData)
        
        currentTimeForTable = Int(NSDate().timeIntervalSince1970)
        UIApplication.shared.statusBarStyle = .lightContent
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        self.view.insertSubview(backgroundImage, at: 0)
        
        checkInTableView.delegate = self
        checkInTableView.dataSource = self
        
        checkInTableView.separatorStyle = .none
        checkInTableView.backgroundColor = UIColor.clear
        checkInTableView.showsVerticalScrollIndicator = false
        checkInTableView.sectionHeaderHeight = 0.0
        checkInTableView.sectionFooterHeight = 0.0
        initializeSample()
        
        loadSavedData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.funcList.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentTimeForTable < hackathonBeginTime) {
            return 2
        } else if(currentTimeForTable > hackathonBeginTime && currentTimeForTable < hackathonEndTime) {
            return events.count + 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            if(currentTimeForTable > hackathonEndTime) {
                return 446
            }
            return 332
        }
        else if(indexPath.row == 1 && currentTimeForTable < hackathonBeginTime) {
            return 120
        } else if(events[indexPath.row - 1].locations?.count == 1) {
            return 179
        } else if(events[indexPath.row - 1].locations?.count == 2) {
            return 215
        } else {
            return 251
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
        
         // first cell should always be the main cell
        if (indexPath.row == 0) {
            if(currentTimeForTable < hackathonBeginTime) { // if the hackathon has not started yet
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellBeforeHackathonCell", for: indexPath) as! mainCellBeforeHackathonCell
                cell.backgroundColor = UIColor.clear
                cell.isUserInteractionEnabled = false;
                return cell
            } else if (currentTimeForTable > hackathonBeginTime && currentTimeForTable < hackingBeginTime) { // if the hackathon has started but hacking has not
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellBeforeHacking", for: indexPath) as! mainCellBeforeHacking
                let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false;
                cell.timeRemaining = cell.eventStartUnixTime - currentUnixTime
                cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
                cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
                cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
                cell.hoursLabel.text = cell.hoursLeft.description
                cell.minutesLabel.text = cell.minutesLeft.description
                cell.secondsLabel.text = cell.secondsLeft.description
                cell.backgroundColor = UIColor.clear
                cell.mTimer.invalidate()
                cell.timeStart()
                cell.backgroundColor = UIColor.clear
                return cell
            } else if (currentTimeForTable > hackathonEndTime) { // if the hackathon has ended
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellAfterHackathon", for: indexPath) as! mainCellAfterHackathon
                cell.isUserInteractionEnabled = false;
                cell.backgroundColor = UIColor.clear
                return cell
            } // otherwise we're hacking currently
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
            let currentUnixTime: Int = Int(NSDate().timeIntervalSince1970)
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false;
            cell.timeRemaining = cell.eventStartUnixTime - currentUnixTime
            cell.secondsLeft = cell.getSeconds(timeInSeconds: cell.timeRemaining)
            cell.minutesLeft = cell.getMinutes(timeInSeconds: cell.timeRemaining)
            cell.hoursLeft = cell.getHours(timeInSeconds: cell.timeRemaining)
            cell.hoursLabel.text = cell.hoursLeft.description
            cell.minutesLabel.text = cell.minutesLeft.description
            cell.secondsLabel.text = cell.secondsLeft.description
            cell.backgroundColor = UIColor.clear
            cell.mTimer.invalidate()
            cell.timeStart()
            return cell
        } else if(indexPath.row == 1 && currentTimeForTable < hackathonBeginTime) { // if hackathon has not started yet
            let cell = tableView.dequeueReusableCell(withIdentifier: "noEventCell", for: indexPath) as! noEventCell
            cell.isUserInteractionEnabled = false;
            cell.backgroundColor = UIColor.clear
            return cell
        } else if (events[indexPath.row - 1].locations?.count == 1){ // we're hacking so show events
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath) as! standardCell
            let dateFormatter = DateFormatter()
            cell.selectionStyle = .none
            
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].startTime!)
            let pressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
            let tempLocations = events[indexPath.row - 1].locations!.value(forKey: "name")
            cell.locationLabel.isUserInteractionEnabled = true
            cell.locationLabel.text = (tempLocations as AnyObject).firstObject as! String?
            cell.locationLabel.addGestureRecognizer(pressGestureRecognizer)

            cell.backgroundColor = UIColor.clear
            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
            cell.qrCodeButton.roundedButton()
            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)

            return cell
        } else if (events[indexPath.row - 1].locations?.count == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoLocationsCell", for: indexPath) as! twoLocationsCell
            let dateFormatter = DateFormatter()
            cell.selectionStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].startTime!)
            let firstPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
            let secondPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
            let tempLocations = events[indexPath.row - 1].locations!.value(forKey: "name")
            cell.firstLocationLabel.text = (tempLocations as AnyObject).object(at: 0) as? String
            cell.secondLocationLabel.text = (tempLocations as AnyObject).object(at: 1) as? String
            
            cell.firstLocationLabel.addGestureRecognizer(firstPressGestureRecognizer)
            cell.secondLocationLabel.addGestureRecognizer(secondPressGestureRecognizer)
            
            cell.firstLocationLabel.isUserInteractionEnabled = true
            cell.secondLocationLabel.isUserInteractionEnabled = true

            cell.backgroundColor = UIColor.clear
            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
            cell.qrCodeButton.roundedButton()
            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)

            return cell
        }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeLocationsCell", for: indexPath) as! threeLocationsCell
            let dateFormatter = DateFormatter()
            cell.selectionStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
        print(events)
            cell.checkInTimeLabel.text = dateFormatter.string(from: events[indexPath.row - 1].startTime!)
            let firstPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
            let secondPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
            let thirdPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationClicked(_:)))
            let tempLocations = events[indexPath.row - 1].locations!.value(forKey: "name")
            cell.firstLocationLabel.text = (tempLocations as AnyObject).object(at: 0) as? String
            cell.secondLocationLabel.text = (tempLocations as AnyObject).object(at: 1) as? String
            cell.thirdLocationLabel.text = (tempLocations as AnyObject).object(at: 2) as? String
        
        

            cell.firstLocationLabel.addGestureRecognizer(firstPressGestureRecognizer)
            cell.secondLocationLabel.addGestureRecognizer(secondPressGestureRecognizer)
            cell.thirdLocationLabel.addGestureRecognizer(thirdPressGestureRecognizer)
        
            cell.firstLocationLabel.isUserInteractionEnabled = true
            cell.secondLocationLabel.isUserInteractionEnabled = true
            cell.thirdLocationLabel.isUserInteractionEnabled = true
        
            cell.backgroundColor = UIColor.clear
            cell.qrCodeButton.backgroundColor = UIColor.fromRGBHex(duskyBlueColor)
            cell.qrCodeButton.roundedButton()
            cell.qrCodeButton.addTarget(self, action: #selector(HomeViewController.buttonClicked), for: .touchUpInside)
            return cell
        
    }
    
    func buttonClicked() {
        self.tabBarController?.selectedIndex = 3
    }
    
    func locationClicked(_ sender: UITapGestureRecognizer) {
        openLocation((sender.view as! UILabel).text!)
    }
    
    func goToProfile(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = storyboard.instantiateInitialViewController()
        self.view.addSubview((profileViewController?.view)!)
        
    }
    
    func loadSavedData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<Feed>(entityName: "Feed")
        
//        fetchRequest.predicate = NSPredicate(format: "startTime > %@", NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        

        
        if let feedArr = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            events = feedArr
        } else {
            events = []
        }
        print ("updated")
        checkInTableView.reloadData()
    }
    
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
    
    func openLocation(_ location_name: String) {
        let locations: [String:Int] = [
            "Thomas M. Siebel Center" : 2,
            "Siebel" : 2,
            "Thomas Siebel Center" : 2,
            "ECEB" : 3,
            "Electrical Computer Engineering Building" : 3,
            "Union" : 4,
            "Illini Union" : 4,
            "DCL" : 1,
            "Digital Computer Laboratory": 1
        ]
        let location_id = locations[location_name]
        print ("location click triggered")
        if let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "Map") as? MapViewController {
            vc.labelPressed = location_id!
            navigationController?.navigationBar.tintColor = UIColor(red: 93.0/255.0, green: 200.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            navigationController?.navigationBar.backgroundColor = UIColor(red: 28.0/255.0, green: 50.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    


}
