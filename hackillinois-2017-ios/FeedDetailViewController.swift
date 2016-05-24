//
//  FeedDetailViewController.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/24/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import GoogleMaps

class FeedDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /* UI Elements */
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var locationTable: UITableView!
    
    /* Variables */
    var locationArray: [Location]!
    var message: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        event.text = message
        
        // Move camera to center of the event
        let location = GMSCameraPosition.cameraWithLatitude(centerOfEventLatitude,
                                                            longitude: centerOfEventLongitude, zoom: 16)
        self.map.camera = location
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // Drop pins to relevant locations
            for location in self.locationArray {
                let position = CLLocationCoordinate2DMake(Double(location.latitude),
                                                          Double(location.longitude))
                let marker = GMSMarker(position: position)
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.title = location.name
                marker.map = self.map
            }
            
            if !self.locationArray.isEmpty {
                self.routeTo(0)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func routeTo(index: Int) {
        map.animateToLocation(CLLocationCoordinate2DMake(Double(locationArray[index].latitude),
            Double(locationArray[index].longitude)))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        routeTo(indexPath.row)
        locationTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FeedDetailTableViewCell?
        cell = locationTable.dequeueReusableCellWithIdentifier("locationCell") as? FeedDetailTableViewCell
        
        if cell == nil {
            cell = FeedDetailTableViewCell(style: .Default, reuseIdentifier: "locationCell")
        }
        
        cell!.location.text = "Route to \(locationArray[indexPath.row].name)"
        return cell!
    }
}
