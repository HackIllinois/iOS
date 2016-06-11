//
//  GenericMapViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/9/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreLocation
import LiquidFloatingActionButton
import MapKit

class GenericMapViewController: UIViewController, CLLocationManagerDelegate, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource, MKMapViewDelegate {
    /* IB Outlets */
    weak var map: MKMapView!
    
    /* Variables */
    var manager: CLLocationManager!
    // Start off the locations and buttons as empty
    var buildings: [Building]! = []
    var liquidCellButtons: [LiquidFloatingCell]! = []
    var button: LiquidFloatingActionButton!
    var locationButton: UIButton!
    var locationSelected = 0
    
    // Mark: Location Button functions
    func setCameraToCurrentLocation() {
        let currentLocation = MKMapCamera(lookingAtCenterCoordinate: (manager.location?.coordinate)!, fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        map.setCamera(currentLocation, animated: true)
        map.selectAnnotation(map.userLocation, animated: true)
    }
    
    func notifyDisabledLocation() {
        /* Authorization is invalid, so warn user to enable it or the feature will contiue to be disabled */
        let ac = UIAlertController(title: "Location Services Required", message: "Location services are required to show your location on the map.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Open Settings", style: .Default, handler: {
            action in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func enableLocationButton() {
        locationButton.setImage(UIImage(named: "ic_my_location")!, forState: .Normal)
        locationButton.removeTarget(nil, action: nil, forControlEvents: .TouchUpInside)
        locationButton.addTarget(self, action: #selector(setCameraToCurrentLocation), forControlEvents: .TouchUpInside)
    }
    
    func disableLocationButton () {
        locationButton.setImage(UIImage(named: "ic_location_disabled"), forState: .Normal)
        locationButton.removeTarget(nil, action: nil, forControlEvents: .TouchUpInside)
        locationButton.addTarget(self, action: #selector(notifyDisabledLocation), forControlEvents: .TouchUpInside)
    }
    
    // Mark: External Application Functions
    /* Handler for opening the map in another application */
    func openInExternalMapApplication() {
        guard !map.selectedAnnotations.isEmpty && map.selectedAnnotations[0].isKindOfClass(Building) else {
            // Check if the location is nil and present an error
            let ac = UIAlertController(title: "Destination not selected", message: "You must select a location before routing.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
            return
        }
        
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
        let location = buildings[locationSelected]
        let daddr = "daddr=\(location.coordinate.latitude),+\(location.coordinate.longitude)"
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
        let location = buildings[locationSelected]
        let daddr = "daddr=\(location.coordinate.latitude),+\(location.coordinate.longitude)"
        let dirflg = "dirflg=w"
        
        let url = "http://maps.apple.com/?\(daddr)&\(dirflg)"
        return NSURL(string: url)!
    }
    
    /* Handler for Apple Maps */
    func appleMapsHandler(alertAction: UIAlertAction) {
        let url = generateAppleMapsURL()
        UIApplication.sharedApplication().openURL(url)
    }
    
    // Mark: View Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if map == nil {
            fatalError("MapView must be configured before calling super classes' constructor")
        }
        
        // Do any additional setup after loading the view.
        manager = CLLocationManager()
        manager.delegate = self
        
        // Configure the map -- set default view to center of event
        map.camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2DMake(centerOfEventLatitude, centerOfEventLongitude),
                                     fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        map.delegate = self
        
        // The rectangle's alignment is hacky due to iOS's autolayout constraints
        let screen = UIScreen.mainScreen().bounds
        let rect = CGRect(x: screen.width - 50, y: screen.height - self.tabBarController!.tabBar.frame.height - 180, width: 40, height: 40)
        
        // Only add the routing options if there are existing elements in buildings
        if !buildings.isEmpty {
            button = LiquidFloatingActionButton(frame: rect)
            button.animateStyle = .Up
            button.dataSource = self
            button.delegate = self
            button.color = UIColor.fromRGBHex(mainUIColor)
            button.enableShadow = false
            map.addSubview(button)
            
            var hue: CGFloat = 5.0 / 360.0
            
            for building in buildings {
                // Create liquid cells
                let locationCell = CustomLiquidCell(icon: UIImage(named: "ic_forward_48pt")!, name: building.shortName!)
                locationCell.color = UIColor(hue: hue, saturation: 74/100, brightness: 90/100, alpha: 1.0) /* #e74c3c */
                hue += 0.05
                liquidCellButtons.append(locationCell)
                
                // Create annotations
                map.addAnnotation(building)
            }
            
            // Add the Open In... Dialogue
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_open_in_new")!, style: .Plain, target: self, action: #selector(openInExternalMapApplication))
        }
        
        // Add "My Location" button
        let locationFrame = CGRect(x: screen.width - 56, y: screen.height - self.tabBarController!.tabBar.frame.height - 132, width: 52, height: 52)
        // Configure button
        locationButton = UIButton(frame: locationFrame)
        locationButton.layer.cornerRadius = 52 / 2  // Circular button
        locationButton.backgroundColor = UIColor.whiteColor()
        map.addSubview(locationButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check for location permissions
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
            disableLocationButton()
        case .AuthorizedWhenInUse:
            // User has given proper permission
            enableLocationButton()
            break
        default:
            // Warn the user that the map is used to determine the user's location
            notifyDisabledLocation()
            disableLocationButton()
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
            enableLocationButton()
        } else {
            disableLocationButton()
        }
    }
    
    // Mark: LiquidFloatingActionButton DataSources
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return liquidCellButtons.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return liquidCellButtons[index]
    }
    
    // Mark: Routing location from current location to user specified location
    func routeTo(destination destination: CLLocationCoordinate2D) {
        guard CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse else {
            // Cannot route if user didn't authorize
            return
        }
        // Remove current paths
        self.map.removeOverlays(self.map.overlays)
        
        // Create new request
        let routeRequest = MKDirectionsRequest()
        routeRequest.source = MKMapItem.mapItemForCurrentLocation()
        routeRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        routeRequest.requestsAlternateRoutes = false
        routeRequest.transportType = .Walking
        
        // Draw the button again to have it "fade"
        // Slignt padding is required to have the circle appear normal: otherwise it will end up clipped
        UIGraphicsBeginImageContextWithOptions(CGSize(width: button.frame.width+8, height: button.frame.height+8), false, 0) // Add slight padding
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.fromRGBHex(mainUIColor).CGColor)
        CGContextSetLineWidth(context, 0)
        
        CGContextAddEllipseInRect(context, CGRect(x: 4, y: 4, width: button.frame.width, height: button.frame.height)) // Add slight padding
        CGContextDrawPath(context, .FillStroke)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imgView = UIImageView(frame: CGRect(x: button.frame.minX-4, y: button.frame.minY-4, width: button.frame.height+8, height: button.frame.width+8))
        imgView.image = img
        map.addSubview(imgView)
        
        /* Configure activity indicator */
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: imgView.frame.width / 2 - 15, y: imgView.frame.height / 2 - 15, width: 30, height: 30))
        activityIndicator.startAnimating()
        activityIndicator.alpha = 0
        
        // Add activity indicator to button
        imgView.addSubview(activityIndicator)
        
        // Animate fading in
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn,
                                   animations: { [unowned self] in
                                    self.button.alpha = 0.0 ; activityIndicator.alpha = 1.0 },
                                   completion: { [unowned self] _ in
                                    self.button.hidden = true })
        
        // Obtain direction
        let directions = MKDirections(request: routeRequest)
        directions.calculateDirectionsWithCompletionHandler() { [unowned self] (response: MKDirectionsResponse?, error: NSError?) in
            if let routes = response?.routes {
                self.map.addOverlay(routes[0].polyline)
            } else if let _ = error {
                print("\(error!)")
            }
            
            // Animate showing button again
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn,
                                       animations: { [unowned self] in
                                        self.button.alpha = 1.0 ; activityIndicator.alpha = 0.0 },
                                       completion: { [unowned self] _ in
                                        self.button.hidden = false; activityIndicator.removeFromSuperview(); imgView.removeFromSuperview() })
        }
    }
    
    // Mark: LiquidFloatingActionButton Delegates
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        let building = buildings[index]
        locationSelected = index
        // Configure MapView to show the location user selected
        map.setCamera(MKMapCamera.from(building: building), animated: true)
        let annotation = map.annotationsInMapRect(MKMapRect(origin: MKMapPointForCoordinate(building.coordinate), size: MKMapSize(width: 1, height: 1))).first! as! MKAnnotation
        map.selectAnnotation(annotation, animated: true)
        // Route locations
        routeTo(destination: building.coordinate)
        liquidFloatingActionButton.close()
    }
    
    // Mark: Map View Delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        // Create a renderer
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = liquidCellButtons[locationSelected].color ?? UIColor.fromRGBHex(mainTintColor)
        renderer.lineWidth = strokeWidth
        return renderer
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selectedAnnotation = mapView.selectedAnnotations[0]
        if selectedAnnotation.isKindOfClass(MKUserLocation) {
            // Don't do anything if the user location is selected
            return
        }
        
        // Find index of selected Annotation
        let sorter: (Building -> Bool) = { $0.coordinate == selectedAnnotation.coordinate }
        if let selectedIndex = buildings.indexOf(sorter) {
            locationSelected = selectedIndex
        }
        routeTo(destination: selectedAnnotation.coordinate)
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
