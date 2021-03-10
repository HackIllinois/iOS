//
//  HICircularView.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/5/21.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit

class HICircularView: HIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 0.5 * bounds.width
        clipsToBounds = true

    }

    func changeCircleColor(color: HIColor) {
        backgroundColor <- color
    }

}
