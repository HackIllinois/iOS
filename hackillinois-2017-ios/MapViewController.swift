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
    
    var bottomSheet: BottomViewController!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dclLabel: UILabel!
    @IBOutlet weak var unionLabel: UILabel!
    @IBOutlet weak var ecebLabel: UILabel!
    @IBOutlet weak var siebelLabel: UILabel!
    @IBOutlet weak var kennyLabel: UILabel!
    
    @IBOutlet weak var directionTitleOverlay: UIView!
    @IBOutlet weak var directionTitle: UILabel!
    
    var labelPressed = 0
    
    var directionModeLabel = 0
    var isDirectionMode = false
    var directionModeTitle = "Room number, Somewhere on Earth"
    
    func closeCleanUp() {
        map.removeOverlays(map.overlays)
        map.deselectAnnotation(map.selectedAnnotations[0], animated: true)
        clearLabel(labelNumber: -1)
    }
    
    // Mark: Initializing locations and where locations are set
    /* Modify this function to change the locations available */
    func initializeLocations() {
        // Create Points for event locations
        let dcl: Location! = CoreDataHelpers.createOrFetchLocation(id: 4, latitude: 40.113140, longitude: -88.226589, locationName: "Digital Computer Laboratory",  shortName: "DCL",  feeds: nil)
        buildings.append(Building(location: dcl))
        
        let siebel: Location! = CoreDataHelpers.createOrFetchLocation(id: 1, latitude: 40.113926, longitude: -88.224916, locationName: "Thomas M. Siebel Center", shortName: "Siebel", feeds: nil)
        buildings.append(Building(location: siebel))
        
        let eceb: Location! = CoreDataHelpers.createOrFetchLocation(id: 2,  latitude: 40.114828, longitude: -88.228049, locationName: "Electrical Computer Engineering Building", shortName: "ECEB", feeds: nil)
        buildings.append(Building(location: eceb))
        
        let union: Location! = CoreDataHelpers.createOrFetchLocation(id: 3,  latitude: 40.109395, longitude: -88.227181, locationName: "Illini Union", shortName: "Union", feeds: nil)
        buildings.append(Building(location: union))
        
        
        let kenny: Location! = CoreDataHelpers.createOrFetchLocation(id: 5,  latitude: 40.112897, longitude: -88.227731,locationName: "Kenny Gym Annex", shortName: "Kenny", feeds: nil)
        buildings.append(Building(location: kenny))
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
        
        // update direction mode
        updateDirectionModeState()
        
        // Set up background gradient
        let gradient = CAGradientLayer()
        let colorBottom = UIColor(red: 20/255, green: 36/255, blue: 66/255, alpha: 1.0)
        let colorTop = UIColor(red: 28/255, green: 50/255, blue: 90/255, alpha: 1.0)
        gradient.colors = [ colorTop.cgColor, colorBottom.cgColor ]
        gradient.locations = [ 0.0, 1.0 ]
        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func updateDirectionModeState() {
        if isDirectionMode {
            directionTitleOverlay.isHidden = false
            directionTitle.text = directionModeTitle
            navigationItem.title = "Directions"
        } else {
            directionTitleOverlay.isHidden = true
            navigationItem.title = "Maps"
        }
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
        
        let kennyTouch = UITapGestureRecognizer(target: self, action: #selector(kennyLabelTouched))
        kennyTouch.numberOfTapsRequired = 1
        kennyLabel.addGestureRecognizer(kennyTouch)
        kennyLabel.isUserInteractionEnabled = true
        
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
        
        kennyLabel.layer.shadowRadius = 4.0
        kennyLabel.layer.shadowOpacity = 0
        kennyLabel.layer.shadowColor = UIColor.hiaSeafoamBlue.cgColor
        kennyLabel.layer.shouldRasterize = true
        kennyLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        if directionModeLabel > 5 {
            UIAlertView(title: "Location id error", message: "Location id \(directionModeLabel) is not a valid id.", delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            [{ _ in }, dclLabelTouched, siebelLabelTouched, ecebLabelTouched, unionLabelTouched, kennyLabelTouched][directionModeLabel]()
        }
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
            kennyLabel.textColor = UIColor.hiaFadedBlue
            kennyLabel.layer.shadowOpacity = 0
            break
        case -1:
            print("reset")
            // RESET ALL
            dclLabel.textColor = UIColor.hiaFadedBlue
            siebelLabel.textColor = UIColor.hiaFadedBlue
            ecebLabel.textColor = UIColor.hiaFadedBlue
            unionLabel.textColor = UIColor.hiaFadedBlue
            kennyLabel.textColor = UIColor.hiaFadedBlue
            dclLabel.layer.shadowOpacity = 0
            siebelLabel.layer.shadowOpacity = 0
            ecebLabel.layer.shadowOpacity = 0
            unionLabel.layer.shadowOpacity = 0
            kennyLabel.layer.shadowOpacity = 0
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
    
    func kennyLabelTouched() {
        clearLabel(labelNumber: labelPressed)
        kennyLabel.layer.shadowOpacity = 1
        kennyLabel.textColor = UIColor.hiaSeafoamBlue
        labelPressed = 5
        
        loadAddress()
    }
    
    func loadAddress() {
        let building = buildings[labelPressed-1]
        let selected_location_id = labelPressed
        
        // Configure MapView to show the location user selected
        map.setCamera(MKMapCamera.from(building: building), animated: true)
        let annotation = map.annotations(in: MKMapRect(origin: MKMapPointForCoordinate(building.coordinate), size: MKMapSize(width: 1, height: 1))).first! as! MKAnnotation
        map.selectAnnotation(annotation, animated: true)
        // Route locations
        routeTo(building.coordinate, completion: { (route: MKRoute?) in
            self.bottomSheet.directions = route
            self.bottomSheet.reloadNavTable(address: building.address ?? "", name: building.longName ?? "", location_id: selected_location_id)
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
            return
        }
        
        // Find index of selected Annotation
        let sorter: ((Building) -> Bool) = { $0.coordinate == selectedAnnotation.coordinate }
        if let selectedIndex = buildings.index(where: sorter) {
            let building = buildings[selectedIndex]
            routeTo(building.coordinate, completion: { (route: MKRoute?) in
                self.bottomSheet.directions = route
                self.bottomSheet.reloadNavTable(address: building.address ?? "", name: building.longName ?? "", location_id: selectedIndex + 1)
                self.bottomSheet.scrollToButtons()
            })
            
            // Set appropriate selection for cleanup later
            clearLabel(labelNumber: -1) // Clear everything
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
            case 4:
                kennyLabel.textColor = UIColor.hiaSeafoamBlue
                kennyLabel.layer.shadowOpacity = 1
                break
            default:
                break
            }
            labelPressed = Int(selectedIndex)+1
            
            if selectedIndex + 1 != directionModeLabel {
                isDirectionMode = false
                updateDirectionModeState()
            }
        }
    }
}
