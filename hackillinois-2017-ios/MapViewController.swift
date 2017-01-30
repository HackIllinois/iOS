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
    
    var bottomSheet : BottomViewController!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dclLabel: UILabel!
    @IBOutlet weak var unionLabel: UILabel!
    @IBOutlet weak var ecebLabel: UILabel!
    @IBOutlet weak var siebelLabel: UILabel!
    
    var labelPressed: Int = 0
    /*
    @IBAction func mapControlChange(_ sender: Any) {
        if(mapControl.selectedSegmentIndex == -1) {
            return
        }
        
        let building = buildings[mapControl.selectedSegmentIndex]
        
        locationSelected = mapControl.selectedSegmentIndex
        // Configure MapView to show the location user selected
        map.setCamera(MKMapCamera.from(building: building), animated: true)
        let annotation = map.annotations(in: MKMapRect(origin: MKMapPointForCoordinate(building.coordinate), size: MKMapSize(width: 1, height: 1))).first! as! MKAnnotation
        map.selectAnnotation(annotation, animated: true)
        // Route locations
        routeTo(building.coordinate, completion: { (route: MKRoute?) in
            self.bottomSheet.directions = route
            self.bottomSheet.reloadNavTable()
        })
        
        bottomSheet.scrollToBar()
    }
    */
    
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
        
        // mapControl.selectedSegmentIndex = UISegmentedControlNoSegment
        let tapMap = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.didDragMap(gestureRecognizer:)))
        tapMap.delegate = self
        map.addGestureRecognizer(tapMap)
        
        addBottomSheetView()
        
        initTouches()
    }
    
    func initTouches() {
        let dclTouch = UITapGestureRecognizer(target: self, action: #selector(dclLabelTouched))
        dclTouch.numberOfTapsRequired = 1
        dclLabel.addGestureRecognizer(dclTouch)
        dclLabel.isUserInteractionEnabled = true
        
        let siebelTouch = UITapGestureRecognizer(target: self, action: #selector(siebelLabelTouched))
        siebelTouch.numberOfTapsRequired = 1
        siebelLabel.addGestureRecognizer(siebelTouch)
        siebelLabel.isUserInteractionEnabled = true
        
        let ecebTouch = UITapGestureRecognizer(target: self, action: #selector(ecebLabelTouched))
        ecebTouch.numberOfTapsRequired = 1
        ecebLabel.addGestureRecognizer(ecebTouch)
        ecebLabel.isUserInteractionEnabled = true
        
        let unionTouch = UITapGestureRecognizer(target: self, action: #selector(unionLabelTouched))
        unionTouch.numberOfTapsRequired = 1
        unionLabel.addGestureRecognizer(unionTouch)
        unionLabel.isUserInteractionEnabled = true
        
        dclLabel.layer.shadowRadius = 4.0
        dclLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        dclLabel.layer.shouldRasterize = true
        
        siebelLabel.layer.shadowRadius = 4.0
        siebelLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        siebelLabel.layer.shouldRasterize = true
        
        ecebLabel.layer.shadowRadius = 4.0
        ecebLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        ecebLabel.layer.shouldRasterize = true
        
        unionLabel.layer.shadowRadius = 4.0
        unionLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        unionLabel.layer.shouldRasterize = true
    }
    
    func clearLabel(labelNumber: Int) {
        switch labelNumber {
        case 1:
            dclLabel.layer.shadowOpacity = 0
            dclLabel.textColor = UIColor.hiaFadedBlue
            break
        case 2:
            siebelLabel.layer.shadowOpacity = 0
            siebelLabel.textColor = UIColor.hiaFadedBlue
            break
        case 3:
            ecebLabel.layer.shadowOpacity = 0
            ecebLabel.textColor = UIColor.hiaFadedBlue
            break
        case 4:
            unionLabel.layer.shadowOpacity = 0
            unionLabel.textColor = UIColor.hiaFadedBlue
            break
        case 5:
            // RESET ALL
            dclLabel.layer.shadowOpacity = 0
            siebelLabel.layer.shadowOpacity = 0
            unionLabel.layer.shadowOpacity = 0
            ecebLabel.layer.shadowOpacity = 0
            dclLabel.textColor = UIColor.hiaFadedBlue
            siebelLabel.textColor = UIColor.hiaFadedBlue
            ecebLabel.textColor = UIColor.hiaFadedBlue
            unionLabel.textColor = UIColor.hiaFadedBlue
            labelPressed = 0
        default:
            break
        }
    }
    
    func dclLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        dclLabel.layer.shadowOpacity = 1
        dclLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 1
    }
    
    func siebelLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        siebelLabel.layer.shadowOpacity = 1
        siebelLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 2
    }
    
    func ecebLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        ecebLabel.layer.shadowOpacity = 1
        ecebLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 3
    }
    
    func unionLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        unionLabel.layer.shadowOpacity = 1
        unionLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            // mapControl.selectedSegmentIndex = UISegmentedControlNoSegment
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func addBottomSheetView() {
        self.bottomSheet = self.storyboard?.instantiateViewController(withIdentifier: "BottomView") as! BottomViewController
        // bottomSheet?.view.backgroundColor = UIColor.clear
        // bottomSheet?.modalPresentationStyle = .overCurrentContext
        self.addChildViewController(bottomSheet!)
        
        self.view.addSubview((bottomSheet?.view)!)
        self.bottomSheet?.didMove(toParentViewController: self)
        
        let height = UIScreen.main.bounds.size.height
        let width  = UIScreen.main.bounds.size.width
        self.bottomSheet?.view.frame = CGRect(x:0, y:self.view.frame.maxY, width:width, height:height)
        
        bottomSheet.hideView(animate: false)
    }

}
