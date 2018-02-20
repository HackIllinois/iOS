//
//  HITextField.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 2/19/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HITextField: UITextField {
    enum Style {
        case none
        case standard
        case username
        case password
    }
    
    init(style: Style) {
        super.init(frame: .zero)
        
    }
}
