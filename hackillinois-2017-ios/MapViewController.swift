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

class MapViewController: UIViewController, CLLocationManagerDelegate, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource, MKMapViewDelegate {

    /* IB Outlets */
    @IBOutlet weak var mapView: MKMapView!
    
    /* Variables */
    var manager: CLLocationManager!
    // Start off the locations and buttons as empty
    var buildings: [Building]! = []
    var liquidCellButtons: [LiquidFloatingCell]! = []
    var button: LiquidFloatingActionButton!
    var locationSelected = 0
    
    // Mark: Initilizing locations and where locations are set
    /* Modify this function to change the locations available */
    func initializeLocations() {
        // Create Points for event locations
        
        // Siebel
        let siebel =
            Building(title: "Thomas Siebel Center for Computer Science", coordinate: CLLocationCoordinate2DMake(40.113926, -88.224916), shortName: "Siebel")
        buildings.append(siebel)
        
        // ECEB
        let eceb =
            Building(title: "Electrical and Computer Engineering Building", coordinate: CLLocationCoordinate2DMake(40.114828, -88.228049), shortName: "ECEB")
        buildings.append(eceb)
        
        // Illini Union
        let union =
            Building(title: "Illini Union", coordinate: CLLocationCoordinate2DMake(40.109395, -88.227181), shortName: "Union")
        buildings.append(union)
        
        // Add Buildings to the Map
        mapView.addAnnotations(buildings)
        
        // Configure the map -- set default view to center of event
        mapView.camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2DMake(centerOfEventLatitude, centerOfEventLongitude),
                                     fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        mapView.delegate = self
        
        // The rectangle's alignment is hacky due to iOS's autolayout constraints
        let screen = UIScreen.mainScreen().bounds
        let rect = CGRect(x: screen.width - 50, y: screen.height - self.tabBarController!.tabBar.frame.height - 180, width: 40, height: 40)
        
        button = LiquidFloatingActionButton(frame: rect)
        button.animateStyle = .Up
        button.dataSource = self
        button.delegate = self
        button.color = UIColor.fromRGBHex(mainUIColor)
        button.enableShadow = false
        
        var hue: CGFloat = 5.0 / 360.0
        
        for building in buildings {
            let locationCell = CustomLiquidCell(icon: UIImage(named: "ic_forward_48pt")!, name: building.short!)
            locationCell.color = UIColor(hue: hue, saturation: 74/100, brightness: 90/100, alpha: 1.0) /* #e74c3c */
            hue += 0.05
            liquidCellButtons.append(locationCell)
        }
        
        mapView.addSubview(button)
        
        // Add "My Location" button
        let locationFrame = CGRect(x: screen.width - 56, y: screen.height - self.tabBarController!.tabBar.frame.height - 132, width: 52, height: 52)
        // Configure button
        let locationButton = UIButton(frame: locationFrame)
        locationButton.layer.cornerRadius = 52 / 2  // Circular button
        locationButton.setImage(UIImage(named: "ic_my_location")!, forState: .Normal)
        locationButton.backgroundColor = UIColor.whiteColor()
        locationButton.addTarget(self, action: #selector(setCameraToCurrentLocation), forControlEvents: .TouchUpInside)
        mapView.addSubview(locationButton)
    }
    
    func setCameraToCurrentLocation() {
        let currentLocation = MKMapCamera(lookingAtCenterCoordinate: (manager.location?.coordinate)!, fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        mapView.setCamera(currentLocation, animated: true)
        mapView.selectAnnotation(mapView.userLocation, animated: true)
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
            mapView.showsUserLocation = true
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
        // Remove current paths
        self.mapView.removeOverlays(self.mapView.overlays)
        
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
        mapView.addSubview(imgView)
        
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
                self.mapView.addOverlay(routes[0].polyline)
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
        mapView.setCamera(MKMapCamera.from(building: building), animated: true)
        let annotation = mapView.annotationsInMapRect(MKMapRect(origin: MKMapPointForCoordinate(building.coordinate), size: MKMapSize(width: 1, height: 1))).first! as! MKAnnotation
        mapView.selectAnnotation(annotation, animated: true)
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
