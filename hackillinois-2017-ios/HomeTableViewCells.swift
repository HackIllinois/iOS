//
//  standardCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit

class HomeTableViewMainCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    var buttons = [LocationButton]()
    
    var locations = [String]() {
        didSet {
            for button in buttons {
                button.removeFromSuperview()
            }
            buttons.removeAll()
            for location in locations {
                let newButton = UINib(nibName: "LocationButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LocationButton
                newButton.button.setTitle(location, for: .normal)
                buttons.append(newButton)
                verticalStackView.addArrangedSubview(newButton)
            }
        }
    }
    
    
    
    
    
    
    
}

