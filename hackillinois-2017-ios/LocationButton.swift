//
//  LocationButton.swift
//  hackillinois-2017-ios
//
//  Created by Rauhul Varma on 2/18/17.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation

class LocationButton: UIView {
    @IBOutlet weak var button: UIButton!
}

@objc
protocol LocationButtonContainerDelegate {
    func locationButtonTapped(location: Location)
}

@objc
protocol LocationButtonContainer {
    var buttons: [LocationButton] { get set }
    var locations: [Location] { get set}
}
