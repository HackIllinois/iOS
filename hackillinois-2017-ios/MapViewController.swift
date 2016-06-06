//
//  MapViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/2/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import GoogleMaps
import LiquidFloatingActionButton

class MapViewController: UIViewController, CLLocationManagerDelegate, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {

    /* IB Outlets */
    @IBOutlet weak var map: GMSMapView!
    
    /* Variables */
    var manager: CLLocationManager!
    // Start off the locations and buttons as empty
    var locations: [String: CLLocationCoordinate2D]! = [:]
    var buttons: [LiquidFloatingCell]! = []
    
    // Mark: Initilizing locations and where locations are set
    /* Modify this function to change the locations available */
    func initializeLocations() {
        // Create Points for event locations
        locations["siebel"] = CLLocationCoordinate2DMake(40.113926, -88.224916)
        
        locations["eceb"] = CLLocationCoordinate2DMake(40.114828, -88.228049)
        locations["union"] = CLLocationCoordinate2DMake(40.109395, -88.227181)
        
        // Siebel
        let siebel = GMSMarker(position: locations["siebel"]!)
        siebel.title = "Thomas Siebel Center for Computer Science"
        siebel.map = map
        
        // ECEB
        let eceb = GMSMarker(position: locations["eceb"]!)
        eceb.title = "Electrical and Computer Engineering Building"
        eceb.map = map
        
        // Illini Union
        let union = GMSMarker(position: locations["union"]!)
        union.title = "Illini Union"
        union.map = map
        
        print("Map's bounds-- x: \(map.bounds.maxX) y: \(map.bounds.maxY)")
        
        // The rectangle's alignment is hacky due to iOS's autolayout constraints
        // TODO: Find a more dynamic, better alignment
        let screen = UIScreen.mainScreen().bounds
        
        // Google's button is 100x100 with 10 point bounds (which is included already)
        let rect = CGRect(x: screen.width - 50, y: screen.height - self.tabBarController!.tabBar.frame.height - 180, width: 40, height: 40)
        
        let button = LiquidFloatingActionButton(frame: rect)
        button.animateStyle = .Up
        button.dataSource = self
        button.delegate = self
        
        buttons.append(LiquidFloatingCell(icon: UIImage(named: "ic_forward_48pt")!))
        buttons.append(LiquidFloatingCell(icon: UIImage(named: "ic_forward_48pt")!))
        buttons.append(LiquidFloatingCell(icon: UIImage(named: "ic_forward_48pt")!))
        
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
        
        // Adjust map
        map.camera = GMSCameraPosition.cameraWithLatitude(40.109395, longitude: -88.227581, zoom: 15)
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
            map.myLocationEnabled = true
            map.settings.myLocationButton = true
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
