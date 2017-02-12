//
//  MapViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 6/2/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: GenericMapViewController, UIGestureRecognizerDelegate, UIToolbarDelegate  {
    
    var bottomSheet : BottomViewController!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dclLabel: UILabel!
    @IBOutlet weak var unionLabel: UILabel!
    @IBOutlet weak var ecebLabel: UILabel!
    @IBOutlet weak var siebelLabel: UILabel!
    
    var labelPressed: Int = 0
    
    func closeCleanUp() {
        self.map.removeOverlays(self.map.overlays)
        self.map.deselectAnnotation(self.map.selectedAnnotations[0], animated: true)
        self.clearLabel(labelNumber: 5)
    }
    
    // Mark: Initializing locations and where locations are set
    /* Modify this function to change the locations available */
    func initializeLocations() {
        // Create Points for event locations
        let dcl: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 4, location: "Digital Computer Laboratory", abbreviation: "DCL", locationLatitude: 40.113140, locationLongitude: -88.226589, locationFeeds: nil)
        buildings.append(Building(location: dcl))
        
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 1, location: "Thomas M. Siebel Center", abbreviation: "Siebel",locationLatitude: 40.113926, locationLongitude: -88.224916, locationFeeds: nil)
        buildings.append(Building(location: siebel))
        
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 2, location: "Electrical Computer Engineering Building", abbreviation: "ECEB", locationLatitude: 40.114828, locationLongitude: -88.228049, locationFeeds: nil)
        buildings.append(Building(location: eceb))
        
        let union: Location! = CoreDataHelpers.createOrFetchLocation(idNum: 3, location: "Illini Union", abbreviation: "Union", locationLatitude: 40.109395, locationLongitude: -88.227181, locationFeeds: nil)
        buildings.append(Building(location: union))
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
        dclLabel.layer.shadowOpacity = 0
        dclLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        dclLabel.layer.shouldRasterize = true
        dclLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        siebelLabel.layer.shadowRadius = 4.0
        siebelLabel.layer.shadowOpacity = 0
        siebelLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        siebelLabel.layer.shouldRasterize = true
        siebelLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        ecebLabel.layer.shadowRadius = 4.0
        ecebLabel.layer.shadowOpacity = 0
        ecebLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        ecebLabel.layer.shouldRasterize = true
        ecebLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        unionLabel.layer.shadowRadius = 4.0
        unionLabel.layer.shadowOpacity = 0
        unionLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        unionLabel.layer.shouldRasterize = true
        unionLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        [{ _ in }, dclLabelTouched, siebelLabelTouched, ecebLabelTouched, unionLabelTouched][labelPressed]()
    }
    
    func clearLabel(labelNumber: Int) {
        switch labelNumber {
        case 1:
            dclLabel.textColor = UIColor.hiaFadedBlue
            dclLabel.layer.shadowOpacity = 0
            break
        case 2:
            siebelLabel.textColor = UIColor.hiaFadedBlue
            siebelLabel.layer.shadowOpacity = 0
            break
        case 3:
            ecebLabel.textColor = UIColor.hiaFadedBlue
            ecebLabel.layer.shadowOpacity = 0
            break
        case 4:
            unionLabel.textColor = UIColor.hiaFadedBlue
            unionLabel.layer.shadowOpacity = 0
            break
        case 5:
            print("reset")
            // RESET ALL
            dclLabel.textColor = UIColor.hiaFadedBlue
            siebelLabel.textColor = UIColor.hiaFadedBlue
            ecebLabel.textColor = UIColor.hiaFadedBlue
            unionLabel.textColor = UIColor.hiaFadedBlue
            dclLabel.layer.shadowOpacity = 0
            siebelLabel.layer.shadowOpacity = 0
            ecebLabel.layer.shadowOpacity = 0
            unionLabel.layer.shadowOpacity = 0
            labelPressed = 0
        default:
            break
        }
    }
    
    func dclLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        print("DCL")
        dclLabel.layer.shadowOpacity = 1
        dclLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 1
        
        loadAddress()
    }
    
    func siebelLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        siebelLabel.layer.shadowOpacity = 1
        siebelLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 2
        
        loadAddress()
    }
    
    func ecebLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        ecebLabel.layer.shadowOpacity = 1
        ecebLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 3
        
        loadAddress()
    }
    
    func unionLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        unionLabel.layer.shadowOpacity = 1
        unionLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 4
        
        loadAddress()
    }
    
    func loadAddress() {
        let building = buildings[labelPressed-1]
        
        // Configure MapView to show the location user selected
        map.setCamera(MKMapCamera.from(building: building), animated: true)
        let annotation = map.annotations(in: MKMapRect(origin: MKMapPointForCoordinate(building.coordinate), size: MKMapSize(width: 1, height: 1))).first! as! MKAnnotation
        map.selectAnnotation(annotation, animated: true)
        // Route locations
        routeTo(building.coordinate, completion: { (route: MKRoute?) in
            self.bottomSheet.directions = route
            self.bottomSheet.reloadNavTable(address: building.address ?? "", name: building.longName ?? "")
            self.bottomSheet.scrollToButtons()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if bottomSheet == nil {
            addBottomSheetView()
        }
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
        
        bottomSheet.globalCloseHandler = closeCleanUp
    }

    override func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = mapView.selectedAnnotations[0]
        if selectedAnnotation.isKind(of: MKUserLocation.self) {
            // Don't do anything if the user location is selected
            return
        }
        
        // Find index of selected Annotation
        let sorter: ((Building) -> Bool) = { $0.coordinate == selectedAnnotation.coordinate }
        if let selectedIndex = buildings.index(where: sorter) {
            let building = buildings[selectedIndex]
            routeTo(building.coordinate, completion: { (route: MKRoute?) in
                self.bottomSheet.directions = route
                self.bottomSheet.reloadNavTable(address: building.address ?? "", name: building.longName ?? "")
                self.bottomSheet.scrollToButtons()
            })
            // Set appropriate selection for cleanup later
            clearLabel(labelNumber: 5) // Clear everything
            switch Int(selectedIndex) {
            case 0:
                dclLabel.textColor = UIColor.hiaSeafoamBlue
                dclLabel.layer.shadowOpacity = 1
                break
            case 1:
                siebelLabel.textColor = UIColor.hiaSeafoamBlue
                siebelLabel.layer.shadowOpacity = 1
                break
            case 2:
                ecebLabel.textColor = UIColor.hiaSeafoamBlue
                ecebLabel.layer.shadowOpacity = 1
                break
            case 3:
                unionLabel.textColor = UIColor.hiaSeafoamBlue
                unionLabel.layer.shadowOpacity = 1
                break
            default:
                break
            }
            labelPressed = Int(selectedIndex)+1
        }
    }
}
