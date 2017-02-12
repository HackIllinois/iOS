//
//  EventDetails.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 08/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var eventDetails:Feed?
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    /* programmatically inflate the event details view */
    func initialize() {
        let tempLocations = eventDetails?.locations!.value(forKey: "name")

        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        
        var locationText:String = ""
        let max = (tempLocations as AnyObject).allObjects!.count
        // display the locations with line break between them
        if(max > 1) {
            for i in 0...(max-2) {
                locationText.append((tempLocations as AnyObject).object(at: i) as! String)
                locationText.append("\n")
            }
        }
        locationText.append((tempLocations as AnyObject).object(at: (max-1)) as! String)
        
        // populate the rest
        eventTitleLabel.text = eventDetails?.name;
        eventStartTime.text = dateFormatter.string(from: (eventDetails?.startTime!)!)
        eventLocationLabel.text = locationText
        eventDescriptionLabel.text = eventDetails?.description_;
    }
}
