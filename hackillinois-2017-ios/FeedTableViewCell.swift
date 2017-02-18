//
//  FeedTableViewCell.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/23/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell, LocationButtonContainer {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    @IBOutlet weak var verticalStackView: UIStackView?
    
    weak var delegate: LocationButtonContainerDelegate?
    
    var indexPath: IndexPath?
    var buttons = [LocationButton]()
    var locations = [Location]() {
        didSet {
            for button in buttons {
                button.removeFromSuperview()
            }
            buttons.removeAll()
            for (idx, location) in locations.enumerated() {
                let newButton = UINib(nibName: "LocationButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LocationButton
                newButton.button.setTitle(location.shortName, for: .normal)
                newButton.button.tag = idx
                newButton.button.addTarget(self, action: #selector(locationButtonTapped(button:)), for: .touchUpInside)
                buttons.append(newButton)
                verticalStackView?.addArrangedSubview(newButton)
            }
        }
    }
    
    func locationButtonTapped(button: UIButton) {
        delegate?.locationButtonTapped(location: locations[button.tag])
    }
}
