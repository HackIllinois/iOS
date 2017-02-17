//
//  standardCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit




class HomeTableViewMainCellButton: UIView {
    @IBOutlet weak var button: UIButton!
}

class HomeTableViewMainCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    var buttons = [HomeTableViewMainCellButton]()
    
    var locations = [String]() {
        didSet {
            // add HomeTableViewMainCellButtons
            for button in buttons {
                button.removeFromSuperview()
            }
            buttons.removeAll()
            for location in locations {
                let newButton = UINib(nibName: "HomeTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HomeTableViewMainCellButton
                newButton.button.setTitle(location, for: .normal)
                buttons.append(newButton)
                verticalStackView.addArrangedSubview(newButton)
            }
            
        }
    }
    
    
    
    
    
    
    
}

