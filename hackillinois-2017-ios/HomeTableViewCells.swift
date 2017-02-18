//
//  standardCell.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 1/22/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//
import UIKit

class HomeTableViewMainCell: LocationButtonContainerTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var qrCodeButton: UIButton?
    
    //MARK: - IBActions
    @IBAction func qrCodeButton(_ sender: Any) {
        // TODO: Popup view controller to show QR Code
        print("This button should open a popup view controller to show QR Code")
    }
}

