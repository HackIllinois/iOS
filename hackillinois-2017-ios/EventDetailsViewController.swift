//
//  EventDetails.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 08/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var event: Feed?
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let locations = event?.locations.array as? [Location] ?? []
        let names = locations.map { return $0.name }
        eventLocationLabel.text = names.joined(separator: "\n")
        
        eventTitleLabel.text = event?.name
        eventStartTime.text = HLDateFormatter.shared.string(from: event!.startTime)
        eventDescriptionLabel.text = event?.description_;
    }
}
