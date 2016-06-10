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

class MapViewController: GenericMapViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    // Mark: Initializing locations and where locations are set
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
    }
    
    override func viewDidLoad() {
        /* Required configurations before calling the superclass's constructor */
        map = mapView
        initializeLocations()
        
        /* Call superclass's constructor after configuration */
        super.viewDidLoad()
    }
}
