//
//  standardCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit




class HomeTableViewMainCellButton: UIStackView {
    @IBOutlet weak var button: UIButton!
}

class HomeTableViewMainCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var buttons = [HomeTableViewMainCellButton]()
    
    var locations = [String]() {
        didSet {
            // add HomeTableViewMainCellButtons
        }
    }
    
    
    
    
    
    
    
}

