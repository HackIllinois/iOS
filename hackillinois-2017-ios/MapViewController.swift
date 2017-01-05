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

class MapViewController: GenericMapViewController, UIGestureRecognizerDelegate, UIToolbarDelegate  {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapControl: UISegmentedControl!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func mapControlChange(_ sender: Any) {
        if(mapControl.selectedSegmentIndex == -1){
            return
        }
        
        let building = buildings[mapControl.selectedSegmentIndex]
        
        locationSelected = mapControl.selectedSegmentIndex
        // Configure MapView to show the location user selected
        map.setCamera(MKMapCamera.from(building: building), animated: true)
        let annotation = map.annotations(in: MKMapRect(origin: MKMapPointForCoordinate(building.coordinate), size: MKMapSize(width: 1, height: 1))).first! as! MKAnnotation
        map.selectAnnotation(annotation, animated: true)
        // Route locations
        routeTo(building.coordinate)

    }
    
    // Mark: Initializing locations and where locations are set
    /* Modify this function to change the locations available */
    func initializeLocations() {
        // Create Points for event locations
        
        // Siebel
        let siebel =
            Building(title: "Siebel Center", coordinate: CLLocationCoordinate2DMake(40.113926, -88.224916), shortName: "Siebel")
        buildings.append(siebel)
        
        // ECEB
        let eceb =
            Building(title: "ECEB", coordinate: CLLocationCoordinate2DMake(40.114828, -88.228049), shortName: "ECEB")
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
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        toolbar.delegate = self
        
        
        mapControl.selectedSegmentIndex = UISegmentedControlNoSegment
        let tapMap = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.didDragMap(gestureRecognizer:)))
        tapMap.delegate = self
        map.addGestureRecognizer(tapMap)
        
        //addBottomSheetView()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            mapControl.selectedSegmentIndex = UISegmentedControlNoSegment
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func addBottomSheetView() {
        let bottomSheet = BottomMapViewController()
        self.addChildViewController(bottomSheet)
        self.view.addSubview(bottomSheet.view)
        bottomSheet.didMove(toParentViewController: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheet.view.frame = CGRect(x:0, y:self.view.frame.maxY, width:width, height:height)
    }

}
