//
//  MapViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/2/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
// import GoogleMaps
import MapKit
import LiquidFloatingActionButton

class MapViewController: UIViewController, CLLocationManagerDelegate, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {

    /* IB Outlets */
    @IBOutlet weak var map: MKMapView!
    
    /* Variables */
    var manager: CLLocationManager!
    // Start off the locations and buttons as empty
    var buildings: [Building]! = []
    var buttons: [LiquidFloatingCell]! = []
    
    // Mark: Initilizing locations and where locations are set
    /* Modify this function to change the locations available */
    func initializeLocations() {
        // Create Points for event locations
        
        // Siebel
        let siebel =
            Building(title: "Thomas Siebel Center for Computer Science", coordinate: CLLocationCoordinate2DMake(40.113926, -88.224916))
        buildings.append(siebel)
        
        // ECEB
        let eceb =
            Building(title: "Electrical and Computer Engineering Building", coordinate: CLLocationCoordinate2DMake(40.114828, -88.228049))
        buildings.append(eceb)
        
        // Illini Union
        let union =
            Building(title: "Illini Union", coordinate: CLLocationCoordinate2DMake(40.109395, -88.227181))
        buildings.append(union)
        
        // Add to Map
        map.addAnnotations(buildings)
        
        // The rectangle's alignment is hacky due to iOS's autolayout constraints
        // TODO: Find a more dynamic, better alignment
        let screen = UIScreen.mainScreen().bounds
        
        // Google's button is 100x100 with 10 point bounds (which is included already)
        let rect = CGRect(x: screen.width - 50, y: screen.height - self.tabBarController!.tabBar.frame.height - 180, width: 40, height: 40)
        
        let button = LiquidFloatingActionButton(frame: rect)
        button.animateStyle = .Up
        button.dataSource = self
        button.delegate = self
        button.color = UIColor.fromRGBHex(mainUIColor)
        button.enableShadow = false
        
        var hue: CGFloat = 5.0 / 360.0
        
        for (index, _) in buildings.enumerate() {
            let locationCell = LiquidFloatingCell(icon: UIImage(named: "ic_forward_48pt")!)
            locationCell.color = UIColor(hue: hue, saturation: 74/100, brightness: 90/100, alpha: 1.0) /* #e74c3c */
            hue += 0.05
            buttons.append(locationCell)
        }
        map.addSubview(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Navigation bar
        navigationItem.title = "Map"
        
        manager = CLLocationManager()
        manager.delegate = self

        // Initialize Map data
        initializeLocations()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check for location permissions
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
        case .AuthorizedWhenInUse:
            // User has given proper permission
            break
        default:
            // Warn the user that the map is used to determine the user's location
            /* Authorization is invalid */
            let ac = UIAlertController(title: "Location Services Required", message: "Location services are required to show your location on the map.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Open Settings", style: .Default, handler: {
                action in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            map.showsUserLocation = true
        }
    }
    
    // Mark: LiquidFloatingActionButton DataSources
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return buttons.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return buttons[index]
    }
    
    // Mark: LiquidFloatingActionButton Delegates
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("selected \(index)")
        liquidFloatingActionButton.close()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
