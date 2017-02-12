//
//  EventDetails.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 08/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var eventDetails = Feed();
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        let tempLocations = eventDetails.locations!.value(forKey: "name")
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        
        eventTitleLabel.text = eventDetails.name;
        eventStartTime.text = dateFormatter.string(from: eventDetails.startTime!)
        eventLocationLabel.text = (tempLocations as AnyObject).firstObject as! String
        eventDescriptionLabel.text = eventDetails.description_;
    }
}
