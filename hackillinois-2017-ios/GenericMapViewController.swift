//
//  GenericMapViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/9/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GenericMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    /* IB Outlets */
    weak var map: MKMapView!
    
    /* Variables */
    var manager: CLLocationManager!
    // Start off the locations and buttons as empty
    var buildings: [Building]! = []
    var locationButton: UIButton!
    var locationSelected = 0
    
    // Mark: Location Button functions
    func setCameraToCurrentLocation() {
        let currentLocation = MKMapCamera(lookingAtCenter: (manager.location?.coordinate)!, fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        map.setCamera(currentLocation, animated: true)
        map.selectAnnotation(map.userLocation, animated: true)
    }
    
    func notifyDisabledLocation() {
        /* Authorization is invalid, so warn user to enable it or the feature will contiue to be disabled */
        let ac = UIAlertController(title: "Location Services Required", message: "Location services are required to show your location on the map.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: {
            action in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func enableLocationButton() {
        locationButton.setImage(UIImage(named: "ic_my_location")!, for: UIControlState())
        locationButton.removeTarget(nil, action: nil, for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(setCameraToCurrentLocation), for: .touchUpInside)
    }
    
    func disableLocationButton () {
        locationButton.setImage(UIImage(named: "ic_location_disabled"), for: UIControlState())
        locationButton.removeTarget(nil, action: nil, for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(notifyDisabledLocation), for: .touchUpInside)
    }
    
    // Mark: External Application Functions
    /* Handler for opening the map in another application */
    func openInExternalMapApplication() {
        guard !map.selectedAnnotations.isEmpty && map.selectedAnnotations[0].isKind(of: Building.self) else {
            // Check if the location is nil and present an error
            let ac = UIAlertController(title: "Destination not selected", message: "You must select a location before routing.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
            return
        }
        
        // Build the open in dialogue
        let externalApplicationSelector = UIAlertController(title: "Open in...", message: "Select the application you would like to navigate in.", preferredStyle: .actionSheet)
        // Check which map applications are available
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            externalApplicationSelector.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: googleMapsHandler))
        }
        externalApplicationSelector.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: appleMapsHandler))
        externalApplicationSelector.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(externalApplicationSelector, animated: true, completion: nil)
    }
    
    /* Mark: Generate Google Maps URL */
    func generateGoogleMapsURL() -> URL {
        let location = buildings[locationSelected]
        let daddr = "daddr=\(location.coordinate.latitude),+\(location.coordinate.longitude)"
        let directionsmode = "directionsmode=walking"
        
        let url = "comgooglemaps://?\(daddr)&\(directionsmode)"
        return URL(string: url)!
    }
    
    /* Hander for Google Maps */
    func googleMapsHandler(_ alertAction: UIAlertAction) {
        let url = generateGoogleMapsURL()
        UIApplication.shared.openURL(url)
    }
    
    /* Mark: Generate Apple Maps URL */
    func generateAppleMapsURL() -> URL {
        let location = buildings[locationSelected]
        let daddr = "daddr=\(location.coordinate.latitude),+\(location.coordinate.longitude)"
        let dirflg = "dirflg=w"
        
        let url = "http://maps.apple.com/?\(daddr)&\(dirflg)"
        return URL(string: url)!
    }
    
    /* Handler for Apple Maps */
    func appleMapsHandler(_ alertAction: UIAlertAction) {
        let url = generateAppleMapsURL()
        UIApplication.shared.openURL(url)
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
        map.camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(centerOfEventLatitude, centerOfEventLongitude),
                                     fromDistance: defaultHeight, pitch: defaultPitch, heading: defaultHeading)
        map.delegate = self
        
        // The rectangle's alignment is hacky due to iOS's autolayout constraints
        let screen = UIScreen.main.bounds
                
        // Only add the routing options if there are existing elements in buildings
        if !buildings.isEmpty {
            var hue: CGFloat = 5.0 / 360.0
            
            for building in buildings {
                // Create liquid cells
                let locationCell = CustomLiquidCell(icon: UIImage(named: "ic_forward_48pt")!, name: building.shortName!)
                locationCell.color = UIColor(hue: hue, saturation: 74/100, brightness: 90/100, alpha: 1.0) /* #e74c3c */
                hue += 0.05
                
                // Create annotations
                map.addAnnotation(building)
            }
            
            // Add the Open In... Dialogue
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_open_in_new")!, style: .plain, target: self, action: #selector(openInExternalMapApplication))
        }
        
        // Add "My Location" button
        let locationFrame = CGRect(x: screen.width - 56, y: screen.height - self.tabBarController!.tabBar.frame.height - 168, width: 52, height: 52)
        // Configure button
        locationButton = UIButton(frame: locationFrame)
        locationButton.layer.cornerRadius = 52 / 2  // Circular button
        locationButton.backgroundColor = UIColor.white
        map.addSubview(locationButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check for location permissions
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            disableLocationButton()
        case .authorizedWhenInUse:
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            map.showsUserLocation = true
            enableLocationButton()
        } else {
            disableLocationButton()
        }
    }
    
    // Mark: Routing location from current location to user specified location
    func routeTo(_ destination: CLLocationCoordinate2D) {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            // Cannot route if user didn't authorize
            return
        }
        // Remove current paths
        self.map.removeOverlays(self.map.overlays)
        
        // Create new request
        let routeRequest = MKDirectionsRequest()
        routeRequest.source = MKMapItem.forCurrentLocation()
        routeRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        
        routeRequest.requestsAlternateRoutes = false
        routeRequest.transportType = .any
        
        // Draw the button again to have it "fade"
        // Slignt padding is required to have the circle appear normal: otherwise it will end up clipped
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.fromRGBHex(mainUIColor).cgColor)
        context?.setLineWidth(0)
        
        context?.addEllipse(in: CGRect(x: 4, y: 4, width: locationButton.frame.width, height: locationButton.frame.height)) // Add slight padding
        context?.drawPath(using: .fillStroke)
        
        UIGraphicsEndImageContext()
        
        // Obtain direction
        let directions = MKDirections(request: routeRequest)
        directions.calculate(completionHandler: { (response, error) in
            if let routes = response?.routes {
                self.map.add(routes[0].polyline)
            } else if let _ = error {
                print("\(error!)")
            }
        })
    }
    
    
    // Mark: Map View Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Create a renderer
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.lineWidth = strokeWidth
        renderer.strokeColor = UIColor.blue;
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = mapView.selectedAnnotations[0]
        if selectedAnnotation.isKind(of: MKUserLocation.self) {
            // Don't do anything if the user location is selected
            return
        }
        
        // Find index of selected Annotation
        let sorter: ((Building) -> Bool) = { $0.coordinate == selectedAnnotation.coordinate }
        if let selectedIndex = buildings.index(where: sorter) {
            locationSelected = selectedIndex
        }
        routeTo(selectedAnnotation.coordinate)
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
