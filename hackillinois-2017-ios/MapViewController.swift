//
//  MapViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/2/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {

    /* IB Outlets */
    @IBOutlet weak var map: GMSMapView!
    
    /* Variables */
    var manager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Navigation bar
        navigationItem.title = "Map"
        
        manager = CLLocationManager()
        manager.delegate = self

        // Create Points for event locations
        
        // Siebel
        let siebel = GMSMarker(position: CLLocationCoordinate2DMake(40.113926, -88.224916))
        siebel.title = "Thomas Siebel Center for Computer Science"
        siebel.map = map
        
        // ECEB
        let eceb = GMSMarker(position: CLLocationCoordinate2DMake(40.114828, -88.228049))
        eceb.title = "Electrical and Computer Engineering Building"
        eceb.map = map
        
        // Illini Union
        let union = GMSMarker(position: CLLocationCoordinate2DMake(40.109395, -88.227181))
        union.title = "Illini Union"
        union.map = map
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
