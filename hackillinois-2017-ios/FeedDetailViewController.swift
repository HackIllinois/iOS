//
//  FeedDetailViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/24/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreLocation
import LiquidFloatingActionButton
import MapKit

class FeedDetailViewController: UIViewController, CLLocationManagerDelegate, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {
    
    /* UI Elements */
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    /* Variables */
    var locationArray: [Location]!
    var liquidButtons: [LiquidFloatingCell] = []
    var message: String!
    var manager: CLLocationManager!
    var locationSelected = 0
    
    // Mark: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the "Open In..." Button
        if !locationArray.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open In...", style: .Plain, target: self, action: #selector(openInExternalMapApplication))
        }
        
        // Set up location manager
        manager = CLLocationManager()
        manager.delegate = self
        
        // Do any additional setup after loading the view.
        event.text = message
        
        // If a location exists, move it to the first available one
        if !locationArray.isEmpty {
            let location = locationArray[0]
            mapView.camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2DMake(Double(location.latitude), Double(location.longitude)),
                                         fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
            
            // Configure the Liquid Button
            
            // The rectangle's alignment is hacky due to iOS's autolayout constraints
            let screen = UIScreen.mainScreen().bounds
            
            // Google's button is 100x100 with 10 point bounds (which is included already)
            let rect = CGRect(x: screen.width - 50, y: screen.height - self.tabBarController!.tabBar.frame.height - 280, width: 40, height: 40)
            
            let button = LiquidFloatingActionButton(frame: rect)
            button.animateStyle = .Up
            button.dataSource = self
            button.delegate = self
            button.color = UIColor.fromRGBHex(mainUIColor)
            button.enableShadow = false
            mapView.addSubview(button)
        } else {
            // Move camera to center of the event
            mapView.camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2DMake(centerOfEventLatitude, centerOfEventLatitude),
                                         fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        }
        
        // Set up Markers
        var hue: CGFloat = 5.0 / 360.0
        
        mapView.addAnnotations(locationArray.map({ [unowned self] in
            let locationCell = LiquidFloatingCell(icon: UIImage(named: "ic_forward_48pt")!)
            locationCell.color = UIColor(hue: hue, saturation: 74/100, brightness: 90/100, alpha: 1.0) /* #e74c3c */
            hue += 0.05
            self.liquidButtons.append(locationCell)
            return Building(location: $0)
        }))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            let ac = UIAlertController(title: "Location Services Disabled", message: "Location services are required to show your location on the map and route paths.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Open Settings", style: .Default, handler: {
                action in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
        
    }
    
    /* Handler for opening the map in another application */
    func openInExternalMapApplication() {
        // Build the open in dialogue
        let externalApplicationSelector = UIAlertController(title: "Open in...", message: "Select the application you would like to navigate in.", preferredStyle: .ActionSheet)
        // Check which map applications are available
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!) {
            externalApplicationSelector.addAction(UIAlertAction(title: "Google Maps", style: .Default, handler: googleMapsHandler))
        }
        externalApplicationSelector.addAction(UIAlertAction(title: "Apple Maps", style: .Default, handler: appleMapsHandler))
        externalApplicationSelector.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(externalApplicationSelector, animated: true, completion: nil)
    }
    
    /* Mark: Generate Google Maps URL */
    func generateGoogleMapsURL() -> NSURL {
        let location = locationArray[locationSelected]
        let daddr = "daddr=\(location.latitude),+\(location.longitude)"
        let directionsmode = "directionsmode=walking"
        
        let url = "comgooglemaps://?\(daddr)&\(directionsmode)"
        return NSURL(string: url)!
    }
    
    
    /* Hander for Google Maps */
    func googleMapsHandler(alertAction: UIAlertAction) {
        let url = generateGoogleMapsURL()
        UIApplication.sharedApplication().openURL(url)
    }
    
    /* Mark: Generate Apple Maps URL */
    func generateAppleMapsURL() -> NSURL {
        let location = locationArray[locationSelected]
        let daddr = "daddr=\(location.latitude),+\(location.longitude)"
        let dirflg = "dirflg=w"
        
        let url = "http://maps.apple.com/?\(daddr)&\(dirflg)"
        return NSURL(string: url)!
    }
    
    /* Handler for Apple Maps */
    func appleMapsHandler(alertAction: UIAlertAction) {
        let url = generateAppleMapsURL()
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark - Location Manager Delegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Enable Location for the map when the user allows the application to use the current location
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    // Mark - LiquidAction Button Delegate
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return locationArray.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return liquidButtons[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("selected: \(index)")
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
