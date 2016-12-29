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

class FeedDetailViewController: GenericMapViewController {
    /* UI Elements */
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    /* Variables */
    var message: String!
    
    // Mark: View Controller functions
    override func viewDidLoad() {
        map = mapView
        super.viewDidLoad()
        // Add the "Open In..." Button
        // Do any additional setup after loading the view.
        event.text = message
        
        // If a location exists, move it to the first available one
        if !buildings.isEmpty {
            let building = buildings[0]
            mapView.camera = MKMapCamera.from(building: building)
        }
        
        // Move the location button down
        locationButton.layer.position.y -= 100
    }
}
