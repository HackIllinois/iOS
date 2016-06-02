//
//  FeedDetailViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/24/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftyJSON

class FeedDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    /* UI Elements */
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var locationTable: UITableView!
    
    /* Variables */
    var locationArray: [Location]!
    var message: String!
    var manager: CLLocationManager!
    var routes: [GMSPolyline?] = []
    var locationSelected: Int = 0
    var observerAdded: Bool = false
    
    // Mark: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the "Open In..." Button
        if !locationArray.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open In...", style: .Plain, target: self, action: #selector(openInExternalMapApplication))
        }
        
        // Ask for Location permissions, if never asked
        manager = CLLocationManager()
        manager.delegate = self
        
        // Do any additional setup after loading the view.
        event.text = message
        
        // Move camera to center of the event
        let location = GMSCameraPosition.cameraWithLatitude(centerOfEventLatitude,
                                                            longitude: centerOfEventLongitude, zoom: 16)
        self.map.camera = location
        
        // If a location exists, move it to the first available one
        if !locationArray.isEmpty {
            let location = locationArray[0]
            map.animateToLocation(CLLocationCoordinate2DMake(Double(location.latitude), Double(location.longitude)))
        }
        
        // Set up Markers
        for location in self.locationArray {
            let position = CLLocationCoordinate2DMake(Double(location.latitude),
                                                      Double(location.longitude))
            let marker = GMSMarker(position: position)
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.title = location.name
            marker.map = self.map
            
            // Set up the routes array to have routes be 1 to 1 with the locationArray
            routes.append(nil)
        }
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
    
    override func viewWillDisappear(animated: Bool) {
        // Remove observer in case (will NOP if it doesn't exist)
        
        if observerAdded {
            map.removeObserver(self, forKeyPath: "myLocation", context: nil)
        }
        
        super.viewWillDisappear(animated)
    }
    
    // Find where the map should locate to based off of what the user touches
    func routeTo(index: Int) {
        let latitude = Double(locationArray[index].latitude)
        let longitude = Double(locationArray[index].longitude)
        
        map.animateToLocation(CLLocationCoordinate2DMake(latitude, longitude))
        
        routes[locationSelected]!.spans = [inactiveStrokeColor]
        routes[index]!.spans = [activeStrokeColor]
        locationSelected = index
    }
    
    // Mark: Construct a valid URL for directions
    // Note: Does not check if the user has given permission to access the location, that is done
    // in the routing function.
    func generateDirectionURL(latitude latitude: Double, longitude: Double) -> NSURL {
        let origin = "origin=\(manager.location!.coordinate.latitude),\(manager.location!.coordinate.longitude)"
        let destination = "destination=\(latitude),\(longitude)"
        let mode = "mode=walking"
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let key = "key=\(appDelegate.google_direction_api_key)"
        
        let parameters = "json?\(origin)&\(destination)&\(mode)&\(key)"
        let url = "https://maps.googleapis.com/maps/api/directions/\(parameters)"
        
        return NSURL(string: url)!
    }
    
    /* Plot available paths in the map view */
    func plotPaths() {
        for (index, location) in locationArray.enumerate() {
            // Find a path from the user's current location to the event location
            // Should only work when the user has given permission to access their current location
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
                let directionData = NSData(contentsOfURL:
                    self.generateDirectionURL(latitude: Double(location.latitude), longitude: Double(location.longitude)))
                let json = JSON(data: directionData!)
                let encodedPath = json["routes"][0]["overview_polyline"]["points"].stringValue
                dispatch_async(dispatch_get_main_queue()) {
                    // Configure the path
                    let path = GMSPolyline(path: GMSPath(fromEncodedPath: encodedPath))
                    path.strokeWidth = strokeWidth
                    path.spans = [inactiveStrokeColor]
                    path.map = self.map
                    
                    // Add the path to all routes
                    self.routes[index] = path
                }
            }
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
    func generateGoogleMapsURL(index: Int) -> NSURL {
        let location = locationArray[locationSelected]
        let daddr = "daddr=\(location.latitude),+\(location.longitude)"
        let directionsmode = "directionsmode=walking"
        
        let url = "comgooglemaps://?\(daddr)&\(directionsmode)"
        return NSURL(string: url)!
    }
    
    
    /* Hander for Google Maps */
    func googleMapsHandler(alertAction: UIAlertAction) {
        var indexSelected: Int
        if let index = locationTable.indexPathForSelectedRow?.row {
            indexSelected = index
        } else {
            indexSelected = 0
        }
        
        let url = generateGoogleMapsURL(indexSelected)
        UIApplication.sharedApplication().openURL(url)
    }
    
    /* Mark: Generate Apple Maps URL */
    func generateAppleMapsURL(index: Int) -> NSURL {
        let location = locationArray[locationSelected]
        let daddr = "daddr=\(location.latitude),+\(location.longitude)"
        let dirflg = "dirflg=w"
        
        let url = "http://maps.apple.com/?\(daddr)&\(dirflg)"
        return NSURL(string: url)!
    }
    
    /* Handler for Apple Maps */
    func appleMapsHandler(alertAction: UIAlertAction) {
        var indexSelected: Int
        if let index = locationTable.indexPathForSelectedRow?.row {
            indexSelected = index
        } else {
            indexSelected = 0
        }
        
        let url = generateAppleMapsURL(indexSelected)
        UIApplication.sharedApplication().openURL(url)
    }
    
    /* KVO override for when the user first initiates locations */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // User location was found
        plotPaths()
        
        // Remove observer (we only need the location once to create initial paths)
        map.removeObserver(self, forKeyPath: "myLocation")
        observerAdded = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Mark - Location Manager Delegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Enable Location for the map when the user allows the application to use the current location
        if status == .AuthorizedWhenInUse {
            map.myLocationEnabled = true
            map.settings.myLocationButton = true
            
            // Check if the user location is available
            if manager.location != nil {
                // Plot paths if the location is available
                plotPaths()
            } else {
                // Add an observer to track updated locations, if location was not available
                map.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
                observerAdded = true
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        routeTo(indexPath.row)
        locationSelected = indexPath.row
        locationTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FeedDetailTableViewCell?
        cell = locationTable.dequeueReusableCellWithIdentifier("locationCell") as? FeedDetailTableViewCell
        
        if cell == nil {
            cell = FeedDetailTableViewCell(style: .Default, reuseIdentifier: "locationCell")
        }
        
        cell!.location.text = "Route to \(locationArray[indexPath.row].name)"
        return cell!
    }
}
